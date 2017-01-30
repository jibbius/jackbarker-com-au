$(function() {
//   var ref = new Firebase("https://jack-barker-blog.firebaseio.com/"),
//     postRef = ref.child(slugify(window.location.pathname));
    var postRef = firebase.database().ref('/posts');

    postRef.on('child_added', function(snapshot) {
      var newPost = snapshot.val();
      $(".comments").prepend('<div class="comment">' +
        '<h4>' + newPost.title + '</h4>' +
        '<div class="profile-image"><img src="http://www.gravatar.com/avatar/' + newPost.uid + '?s=100&d=retro"/></div> ' +
        '<span class="date">' + moment(newPost.starCount).fromNow() + '</span><p>' + newPost.body  + '</p></div>');
    });

    $("#comment").submit(function() {
        
        writeNewPost(
            md5($("#email").val()),     // uid
            $("#name").val(),           // username
            md5($("#email").val()),     // picture
            '',                         // title
            $("#message").val()         // body
        );
    //   $("input[type=text], textarea").val("");
      return false;
    });

});


function writeNewPost(uid, username, picture, title, body) {
  // A post entry.
  var postData = {
    author: username,
    uid: uid,
    body: body,
    title: title,
    starCount: 0,
    authorPic: picture
  };

  // Get a key for a new Post.
  var newPostKey = firebase.database().ref().child('posts').push().key;

  // Write the new post's data simultaneously in the posts list and the user's post list.
  var updates = {};
  updates['/posts/' + newPostKey] = postData;
  updates['/user-posts/' + uid + '/' + newPostKey] = postData;

  return firebase.database().ref().update(updates);
}



function slugify(text) {
  return text.toString().toLowerCase().trim()
    .replace(/&/g, '-and-')
    .replace(/[\s\W-]+/g, '-')
    .replace(/[^a-zA-Z0-9-_]+/g,'');
}

 