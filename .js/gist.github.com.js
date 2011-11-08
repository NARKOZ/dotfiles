// adds link to GitHub profile
var href = 'https://github.com/' + $('div.actor div.name a:first').text();

$('div.actor div.name').append('&nbsp;<a href=' + href + ' class="minibutton"><span>GitHub</span></a>');
$('div.actor div.name a:last').hover(
  function() {
    $(this).css("color", "#fff");
  },
  function() {
    $(this).css("color", "#000");
  }
);
