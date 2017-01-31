
function slugify(text) {
  return text.toString().toLowerCase().trim()
    .replace(/&/g, '-and-')
    .replace(/[\s\W-]+/g, '-')
    .replace(/[^a-zA-Z0-9-_]+/g,'');
}

 var post_uid = slugify(window.location.pathname);

$(function() {
    var db = firebase.database();
    var commentRef = db.ref('/posts/' + post_uid + '/comments/');
        
        // Get the comment(s)
    commentRef.on('child_added', function(snapshot) {
      var newComment = snapshot.val();

      $(".comments").append(
        '<div class="comment">' +
          '<h4>' + newComment.author + '</h4>' +
          '<div class="profile-image">' +
            '<img src="http://www.gravatar.com/avatar/' + newComment.author_email_md5 + '?s=100&d=retro"/>' +
          '</div> ' +
          '<span class="date">' + moment(newComment.timestamp).fromNow() + '</span>' +
          '<p>' + newComment.body + '</p>' +
        '</div>');
    });

    $("#comment").submit(function() {      
        writeNewComment(
            post_uid,                   // post_uid
            $("#name").val(),           // author
            $("#email").val(),          // author_email
            $("#message").val()         // comment body
        );

        // Clear the text input
      $("input[type=text], textarea").val("");
      return false;
    });
});


function writeNewComment(post_uid, author, author_email, comment_body) {
  // A comment entry.
  var commentData = {
    post_uid: post_uid,
    timestamp: firebase.database.ServerValue.TIMESTAMP,

    author: author,
    author_email: author_email,
    author_email_md5: md5(author_email),

    title: '',
    body: comment_body
  };

  var updates = {};

  // Get a key for a new Comment.
  var newCommentKey = firebase.database().ref('/posts/' + post_uid + '/comments/').child('comments').push().key;
  
  // Write the new comment to the post's comments list.
  updates['/posts/' + post_uid + '/comments/' + newCommentKey] = commentData;
  return firebase.database().ref().update(updates);
}
