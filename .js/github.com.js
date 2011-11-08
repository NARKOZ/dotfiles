// adds link to Gist profile
var slashcount = window.location.href.split('/').length;

if (slashcount >= 4) {
  var user = document.location.href.replace(/https:\/\/.*\//, '');
  var href = 'https://gist.github.com/' + user;

  $("div.pagehead.userpage ul.pagehead-actions").prepend('<li><a href=' + href + ' class="minibutton"><span>Gist</span></a></li>');
}

// ^_^
if (window.location.href.match(/https:\/\/github.com\/(narkoz|NARKOZ)/)) {
  $("div.first.vcard").prepend('<dl><dt>GitHub Role</dt><dd>Rockstar Developer</dd></dl>');
}

// adds link to Applications
if (window.location.href.match("https://github.com/account")) {
  $("div.pagehead.mine ul.tabs").append('<li><a href="https://github.com/account/applications">Applications</a></li>');
};
