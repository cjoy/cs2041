from flask import url_for
import os
import glob
import yaml, json, sys
import re
from time import gmtime, strftime
import time
import operator
import random
import subprocess

students_dir = "static/dataset-medium";

# posts look-table up for faster searches
posts_store = {}

# Post Object (applies to posts, comments and replies)
class Post:
    # posts constructor
    def __init__(self, fname):
        with open(fname) as f:
            for field in f:
                if field.startswith('from:'):
                    self._from = field[len('from: '):].rstrip()
                if field.startswith('message:'):
                    self.message = field[len('message: '):].rstrip()
                if field.startswith('time:'):
                    self.time = field[len('time: '):].rstrip()
                if field.startswith('longitude:'):
                    self.longitude = field[len('longitude: '):].rstrip()
                if field.startswith('latitude:'):
                    self.latitude = field[len('latitude: '):].rstrip()


# Mail Sender Helper
# Credits - CSE Evan
def send_email(to, subject, message):
    mutt = [
            'mutt',
            '-s',
            subject,
            '-e', 'set copy=no',
            '-e', 'set realname=UNSWtalk',
            '--', to
    ]
    subprocess.run(
            mutt,
            input = message.encode('utf8'),
            stderr = subprocess.PIPE,
            stdout = subprocess.PIPE,
    )


# clean post and comment-ids
# used for steralising jquery tags 
def CleanID (_id):
    _id = _id.replace('/', '-')
    _id = _id.replace('.', '-')
    return _id


# remove static infront of url
def RemoveStatic(url):
    return url.replace('/static/', '')

# allow quotes in yaml files
def literalFile(content):
    content = re.sub('"','\\"',content)
    content = re.sub(':','',content)
    return content

# CREDITS: 
# https://stackoverflow.com/questions/214777/how-do-you-convert-yyyy-mm-ddthhmmss-000z-time-format-to-mm-dd-yyyy-time-forma
def parseTime(tstamp):
    ts = time.strptime(tstamp[:19], "%Y-%m-%dT%H:%M:%S")
    return  time.strftime("Posted on %d/%m/%Y at %H:%M", ts)

# get user image
def GetProfilePic(zid):
    profile_pic = '/static/profile-icon.png'
    file_path = os.path.join(students_dir, zid, "img.jpg")
    if os.path.exists(file_path):
        profile_pic = '/' + file_path
    return profile_pic

# Get user details, given zid
def GetUserDetails(zid):
    details_filename = os.path.join(students_dir, zid, "student.txt")
    details = {}
    if os.path.exists(details_filename):
        with open(details_filename) as f:
            details = yaml.load(f.read())
    return details

# Parse message helper - Replace ZID with Full Name
def helper_name_replace(match):
    zid = match.group()
    user_details = GetUserDetails(zid)
    url = '<a href="' + url_for('profile', zid=zid) + '">' + zid + '</a>'
    if 'full_name' in user_details:
        url = '<a href="' + url_for('profile', zid=zid) + '">' + user_details['full_name'] + '</a>'
    return url

# Parse messages (friends tagging and html in comments)
def ParseMessage(message):
    try:
        message = re.sub(r'(\bz[0-9]{7}\b)', helper_name_replace, message)
        message = message.replace('\\n', '<br>')
        message = message.replace('\\r', '')
        message = message.replace('"', '')
    except:
        message = message
    return message

# Get all users (array of user objects returned)
def GetAllUsers():
    users = []
    for user in sorted(os.listdir(students_dir)):
        users.append(GetUserDetails(user))
    return users


# Search for people
def SearchPeople(query):
    results = []
    for user in GetAllUsers():
        if query.lower() in user['full_name'].lower():
            results.append(user)
    
    return results

# Search for posts 
def SearchPosts(query):
    results = []

    threads = []
    # loop through all users dir
    all_users_dir = os.path.join(students_dir)
    for user in os.listdir(all_users_dir):
        user_dir = os.path.join(students_dir, user)
        # list all higher level posts
        res = [f for f in os.listdir(user_dir) if re.search(r'\d{1,2}.txt', f)]
        for post in res:
            post_file = os.path.join(user_dir, post)

            # cache look up in hash for better run time
            if post_file in posts_store:
                message = posts_store[post_file]
            else:
                try:
                    message = Post(post_file).message # get post message
                except:
                    message = ""

                posts_store[post_file] = message

            if (query.lower() in message):
                # get whole thread (for comments and replies)
                super_file = post_file.split('/')
                super_file_name = super_file[3]
                super_file_name = super_file_name.split('-')
                if '.txt' in super_file_name[0]:
                    super_file_name = super_file_name[0]
                else:
                    super_file_name = super_file_name[0] + '.txt'                    
                whole_thread = os.path.join(super_file[0],
                    super_file[1],super_file[2],super_file_name)
                if whole_thread not in threads:
                    threads.append(whole_thread)

    # after compiling post threads, fetch posts and compile
    for thread in threads:
        results.append(GetPostThread(thread))

    return results


# get post thread, given post id (eg. postid: dataset-medium/z5191841/12.txt)
def GetPostThread(postid):
    comments_array = []
    # loop through comments
    comment_files = glob.glob(postid.split('.txt')[0]+'-[0-99].txt')
    for comment in comment_files:
        replies_array = []
        comment_obj = {
            'id': comment,
            'content': Post(comment),
            'replies': replies_array
        }
        
        # loop through replies
        reply_files = glob.glob(comment.split('.txt')[0]+'-[0-99].txt')
        for reply in reply_files:
            reply_obj = {
                'id': reply,
                'content': Post(reply),
            }
            replies_array.append(reply_obj)

        comments_array.append(comment_obj)

    # create post object
    post_obj = {
        'id': postid,
        'content': Post(postid),
        'comments': comments_array
    }

    return post_obj

# Get user posts, comments to those posts and replies to those posts
def GetUserPosts(zid):
    posts = []

    # get user recent posts
    print("Getting posts for", zid)
    user_dir = os.path.join(students_dir, zid)

    # create user feed
    res = [f for f in os.listdir(user_dir) if re.search(r'^\d{1,2}.txt', f)]
    for post in res:
        post_file = os.path.join(user_dir, post)
        posts.append(GetPostThread(post_file))

    return posts


# Get user feeds
def GetUserFeeds(zid):
    # create user feed
    posts = []

    # get user recent posts
    user_dir = os.path.join(students_dir, zid)
    # list all higher level posts
    res = [f for f in os.listdir(user_dir) if re.search(r'^\d{1,2}.txt', f)]
    for post in res:
        post_file = os.path.join(user_dir, post)
        posts.append(GetPostThread(post_file))

    # loop though friends
    user_details = GetUserDetails(zid)
    friends = list(re.sub(r'(\(|\)|\s)', '', user_details['friends']).split(','))
    for friend in friends:
        # get friend's recent posts
        friend_dir = os.path.join(students_dir, friend)
        for friend_post in reversed(glob.glob(friend_dir+'/[0-9].txt')):
            posts.append(GetPostThread(friend_post))

    # MENTIONS DISABLED - WAY TOO SLOW
    # loop through all mentions
    # all_students = sorted(os.listdir(students_dir))
    # for post in all_students:
    #     # get friend's recent posts
    #     posts_dir = os.path.join(students_dir, post)
    #     for all_post in reversed(glob.glob(posts_dir+'/[0-99].txt')):
    #         posts_content = GetPostThread(all_post)
    #         # append if mentioned
    #         if zid in posts_content['content'].message:
    #             posts.append(posts_content)
    posts = sorted(posts, key=lambda x: str(x['content'].time))

    return reversed(posts)

def MakeCommentPost(parent, message, zid):
    # init sub directories
    sub_file = parent.split('.txt')[0]
    sub_dirs = sub_file.split('/')
    sub_root = os.path.join(sub_dirs[0],sub_dirs[1],sub_dirs[2])
    # find last post & create new file path
    res = [f for f in os.listdir(sub_root) if re.search(r'^'+sub_dirs[3]+'-\d+.txt$', f)]
    last_suffix = 0
    for r in res:
        fn = r.split('.txt')[0]
        ln = fn.rsplit('-')
        if last_suffix < int(ln[len(ln)-1]):
            last_suffix = int(ln[len(ln)-1])
    # new file to write comment onto
    new_file = sub_file+"-"+str(last_suffix+1)+'.txt'
    # get time
    time_now = strftime("%Y-%m-%dT%H:%M:%S+0000", gmtime())
    # save comment
    # write post to file
    new_post = {
        'message': message,
        'time': time_now,
        'from': zid
    }
    # write post
    with open(new_file, 'w') as outfile:
        yaml.dump(new_post, outfile, default_flow_style=False)
    return


def DeletePost(post):
    dir_sub = post.split('/')
    delfile = post.split('.txt')[0]
    delname = delfile.split('/')[3]
    for f in os.listdir(os.path.join(dir_sub[0], dir_sub[1], dir_sub[2])):
        if re.search('^'+delname, f):
            os.remove(os.path.join(dir_sub[0], dir_sub[1], dir_sub[2],f))

    print(delfile)
    return

# check if user and friend are "friends"
def CheckFriend(user,friend):
    user_dir = os.path.join(students_dir, user, 'student.txt')
    user_friends = GetUserDetails(user)['friends'].strip('(').strip(')').split(', ')
    isFriend = False
    if friend in user_friends:
        isFriend = True
    return isFriend

def AddDeleteFriend(action, zid,friend):
    user_dir = os.path.join(students_dir, zid, 'student.txt')
    friend_dir = os.path.join(students_dir, friend, 'student.txt')
    
    # update target friends (bilaterial removal)
    updated_target_friends = GetUserDetails(zid)['friends'].strip('(').strip(')').split(', ')
    updated_target_friends_len = len(updated_target_friends)
    if action == 'add':
        if friend not in updated_target_friends:
            updated_target_friends.append(friend)
    elif action == 'delete':
        if friend in updated_target_friends:
            updated_target_friends.remove(friend)
    updated_target_friends = str(tuple(updated_target_friends))
    if updated_target_friends_len == 2: updated_target_friends = updated_target_friends.replace(',', '')
    updated_target_friends = updated_target_friends.replace('\'', '')

    # update destination friends (bilaterial removal)
    updated_dest_friends = GetUserDetails(friend)['friends'].strip('(').strip(')').split(', ')
    updated_dest_friends_len = len(updated_dest_friends)
    if action == 'add':
        if zid not in updated_dest_friends:
            updated_dest_friends.append(zid)
    elif action == 'delete':
        if zid in updated_dest_friends:
            updated_dest_friends.remove(zid)
    updated_dest_friends = str(tuple(updated_dest_friends))
    if updated_dest_friends_len == 2: updated_dest_friends = updated_dest_friends.replace(',', '')
    updated_dest_friends = updated_dest_friends.replace('\'', '')    

    # create new student objects
    target_obj = GetUserDetails(zid)
    target_obj['friends'] = updated_target_friends
    dest_obj = GetUserDetails(friend)
    dest_obj['friends'] = updated_dest_friends

    # write new user objects to disk
    with open(user_dir, 'w') as outfile:
        yaml.dump(target_obj, outfile, default_flow_style=False)
    with open(friend_dir, 'w') as outfile:
        yaml.dump(dest_obj, outfile, default_flow_style=False)

    # send email notification
    if action == 'add':
        subject = "Friend Request"
        message = "You have a new friend. Go to your UNSWtalk profile to accept the request."
        send_email(GetUserDetails(zid)['email'],subject, message)
        send_email(GetUserDetails(friend)['email'],subject, message)
        
    return


def MakePost(message, zid):
    post_dir = os.path.join(students_dir, zid)
    # list posts in user dir
    res = [f for f in os.listdir(post_dir) if re.search(r'^\d+.txt$', f)]
    # get filename for latest post
    prefix = []
    for f in res: prefix.append(int(f.split('.')[0]))
    try:
        new_file_name = str(max(prefix)+1) + '.txt'
    except:
        new_file_name = '0.txt'
    # get time
    time_now = strftime("%Y-%m-%dT%H:%M:%S+0000", gmtime())
    # write post to file
    new_post = {
        'message': message,
        'time': time_now,
        'from': zid
    }
    # write post
    with open(os.path.join(post_dir, new_file_name), 'w') as outfile:
        yaml.dump(new_post, outfile, default_flow_style=False)

    return

def RegisterAccount(zid, email, full_name, password):
    userObj = {
        'birthday': '1994-06-20',
        'email': email,
        'full_name': full_name,
        'home_suburb': 'UNSW',
        'password': password,
        'program': 'Unspecified',
        'friends': '(z5195935)',
        'courses': '(2017 S2 COMP2041)',
        'zid': zid
    }

    # create new folder for user
    newpath = os.path.join(students_dir, zid)
    if not os.path.exists(newpath):
        os.makedirs(newpath)

    # print(yaml.load(userObj))
    with open(os.path.join(newpath, 'student.txt'), 'w') as outfile:
        yaml.dump(userObj, outfile, default_flow_style=False)

    # send email for student verification
    subject = "Welcome to UNSWtalk"
    message = 'Welcome to UNSWtalk - by Chris Joy <br><br> Please verify your account by clicking on <a href="http://localhost:5000/verify/'+zid+'">this link</a>.'
    send_email(email, subject, message)

    return