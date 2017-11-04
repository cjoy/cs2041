#!/web/cs2041/bin/python3.6.3

# written by andrewt@cse.unsw.edu.au October 2017
# as a starting point for COMP[29]041 assignment 2
# https://cgi.cse.unsw.edu.au/~cs2041/assignments/UNSWtalk/

import os, re
from flask import Flask, render_template, session, request, redirect, url_for
import controller as ctrl

app = Flask(__name__)

# START ROUTE
@app.route('/', methods=['GET','POST'])
def start():
    # protected route - check if user logged in
    if 'logged_in' not in session:
        return redirect(url_for('login'))

    return redirect(url_for('feeds'))

# FEEDS ROUTE
@app.route('/feeds', methods=['GET','POST'])
def feeds():
    # protected route - check if user logged in
    if 'logged_in' not in session:
        return redirect(url_for('login'))

    feeds = ctrl.GetUserFeeds(session['zid'])
    return render_template('feeds.html', title="My Feeds", feeds=feeds,
        getdetails=ctrl.GetUserDetails, GetProfilePic=ctrl.GetProfilePic,
        parseTime=ctrl.parseTime, ParseMessage=ctrl.ParseMessage, 
        RemoveStatic=ctrl.RemoveStatic, CleanID=ctrl.CleanID)

# SEARCH PEOPLE ROUTE
@app.route('/search/people', methods=['GET','POST'])
def search_people():
    # protected route - check if user logged in
    if 'logged_in' not in session:
        return redirect(url_for('login'))

    # get search query
    query = request.args.get('q')
    results = []
    if query == None:
        query = ''
    else:
        # compute search results
        results = ctrl.SearchPeople(query)

    return render_template('search_people.html', title='Search People - "' + query + '"', 
        GetProfilePic=ctrl.GetProfilePic, RemoveStatic=ctrl.RemoveStatic,
        results=results, query=query)

# SEARCH POSTS ROUTE   
@app.route('/search/posts', methods=['GET','POST'])
def search_posts():
    # protected route - check if user logged in
    if 'logged_in' not in session:
        return redirect(url_for('login'))

    # get search query
    query = request.args.get('q')
    results = []
    if query == None:
        query = ''
    else:
        # compute search results
        results = ctrl.SearchPosts(query)

    return render_template('search_posts.html', title='Search Posts - "' + query + '"', 
        getdetails=ctrl.GetUserDetails, GetProfilePic=ctrl.GetProfilePic,
        parseTime=ctrl.parseTime,  ParseMessage=ctrl.ParseMessage, CleanID=ctrl.CleanID,
        results=results, query=query, RemoveStatic=ctrl.RemoveStatic)

# PROFILE ROUTE
@app.route('/profile/<zid>', methods=['GET','POST'])
def profile(zid):
    # protected route - check if user logged in
    if 'logged_in' not in session:
        return redirect(url_for('login'))
        
    student_to_show = zid
    details = ctrl.GetUserDetails(student_to_show)
    posts = ctrl.GetUserPosts(student_to_show)

    courses = details['courses'].strip('(').strip(')').split(', ')
    friends = details['friends'].strip('(').strip(')').split(', ')

    return render_template('profile.html', title=details['full_name'],
        student_details=details, posts=reversed(posts), zid=zid,
        getdetails=ctrl.GetUserDetails, GetProfilePic=ctrl.GetProfilePic,
        parseTime=ctrl.parseTime,  ParseMessage=ctrl.ParseMessage, CleanID=ctrl.CleanID,
        courses=courses, friends=friends, isFriend=ctrl.CheckFriend(session['zid'],zid),
        RemoveStatic=ctrl.RemoveStatic)

# LOGIN ROUTE
@app.route('/login', methods=['GET','POST'])
def login():
    # error status is set to true
    status = True
    # get credentials
    zid = request.form.get('zid')
    password = request.form.get('password')
    # check zid and password and set session
    if zid != None and password != None:
        if ctrl.GetUserDetails(zid)['password'] == password:
            session['logged_in'] = True
            session['zid'] = zid
            session['user_details'] = ctrl.GetUserDetails(zid)
            return redirect(url_for('start'))
        else:
            status = False

    return render_template('login.html', title="Login", status=status)

# REGISTER ROUTE
@app.route('/register', methods=['GET','POST'])
def register():
    # error status is set to true
    status = True
    # get credentials
    post = True
    try:
        zid = request.form.get('zid')
        email = request.form.get('email')
        full_name = request.form.get('full_name')
        password = request.form.get('password')
        confirmPassword = request.form.get('confirmPassword')
    except:
        post = False
        
    # error handling
    if post == False:
        status = False
    else:
        try:
            if password != confirmPassword:
                status = False            
            elif 'zid' in ctrl.GetUserDetails(zid):
                status = False
            elif not re.match(r'(\bz[0-9]{7}\b)', zid):
                status = False
        except:
            status = False

    # create account
    if status == True:
        ctrl.RegisterAccount(zid, email, full_name, password)
        return redirect(url_for('login'))

    return render_template('register.html', title="Register", status=status)

# LOGOUT ROUTE
@app.route('/logout', methods=['GET','POST'])
def logout():
    session.pop('logged_in', None)
    session.pop('zid', None)
    session.pop('user_details', None)
    return redirect(url_for('login'))







# DELETE FRIEND
@app.route('/friend/delete', methods=['POST', 'GET'])
def delete_friend():
    # # protected route - check if user logged in
    if 'logged_in' not in session:
        return redirect(url_for('login'))
    # post error handlr
    post = True
    try:
         friend = request.form.get('friend')
         zid = session['zid']
    except:
        post = False

    if post == True:
        ctrl.AddDeleteFriend('delete', zid, friend)

    return redirect(request.referrer)

# ADD FRIEND
@app.route('/friend/add', methods=['POST', 'GET'])
def add_friend():
    # protected route - check if user logged in
    if 'logged_in' not in session:
        return redirect(url_for('login'))
    # post error handlr
    post = True
    try:
         friend = request.form.get('friend')
         zid = session['zid']
    except:
        post = False

    if post == True:
        ctrl.AddDeleteFriend('add', zid, friend)

    return redirect(request.referrer)

# POST COMMENT ROUTE
@app.route('/post/delete', methods=['POST', 'GET'])
def delete_comment():
    # protected route - check if user logged in
    if 'logged_in' not in session:
        return redirect(url_for('login'))
    # post error handlr bool
    post = True
    try:
        addr = request.form.get('addr')
    except:
        post = False
    if post == True:
        ctrl.DeletePost(addr)

    return redirect(request.referrer)



# POST COMMENT ROUTE
@app.route('/post/comment', methods=['POST', 'GET'])
def new_comment():
    # protected route - check if user logged in
    if 'logged_in' not in session:
        return redirect(url_for('login'))
    # post error handlr bool
    post = True
    try:
        parent = request.form.get('parent')
        content = request.form.get('content')
        zid = session['zid']
    except:
        post = False
    if post == True:
        ctrl.MakeCommentPost(parent, content, zid)
    return redirect(request.referrer)

# POST ROUTE
@app.route('/post', methods=['POST', 'GET'])
def new_post():
    # protected route - check if user logged in
    if 'logged_in' not in session:
        return redirect(url_for('login'))

    ctrl.MakePost(request.form.get('post_content'), session['zid'])
    return redirect(request.referrer)





if __name__ == '__main__':
    app.secret_key = os.urandom(12)
    app.run(debug=True)
