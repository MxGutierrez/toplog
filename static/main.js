// config marked
const renderer = new marked.Renderer();
function paragraphParse(text) {
  return `<p>\n${text}</p>`;
}
function linkParse(href, title, text) {
  const isSelf = href.includes('newdin.com');
  const textIsImage = text.includes('<img');
  return `
  <a href="${href}" target="_blank"
    title="${title || (textIsImage ? href : text)}" 
    ${isSelf ? '' : 'rel="external nofollow noopener noreferrer"'}
  >${text}
  </a>`.replace(/\s+/g, ' ').replace('\n', '');
}
function imageParse(src, title, alt) {
  return `
  <br><a href="${src}" 
    target="_blank" rel="nofollow noopener noreferrer">
    <img src="${src}" title="${title || alt || ''}" 
      style="max-width:95%; max-height:45%"
      alt="${alt || title || src}"
    />
  </a><br>`.replace(/\s+/g, ' ').replace('\n', '');
}
function headingParse(text, level) {
  let realLevel = level + 2;
  return '<h' + realLevel + '>' + text + '</h' + realLevel + '>\n';
}
renderer.link = linkParse;
renderer.image = imageParse;
renderer.paragraph = paragraphParse;
renderer.heading = headingParse;
marked.setOptions({
  gfm: true,
  breaks: true,
  pedantic: false,
  smartLists: true,
  smartypants: true,
  renderer: renderer
})

const PerPage = 20; 
const WPM = 300;
const mapFlag = {'1': 'Todo', '2': 'Doing', '3': 'Done', 'Options': 'Options'};

//## show dropdown
function showMenu() { 
  showDrop("drop-menu"); 
}
function showOption() { 
  showDrop("drop-opt"); 
}
function showDrop(id_name) {
  let show = document.getElementById(id_name);
  if (show) { show.classList.toggle("show");}
}

const TOK = 'NoSeSNekoTr'; // for get cookie token
const IDENT = 'YITnEdIr'  // for get cookie identity
function getCookie(c_name) {
  var c_start = 0, c_end = 0, ck = document.cookie;
  if (ck.length > 0) {
    c_start = ck.indexOf(c_name + "=");
    if (c_start != -1) {
      c_start = c_start + c_name.length + 1;
      c_end = ck.indexOf(";", c_start);
      if (c_end === -1) { c_end = ck.length;}
    }
    var c = ck.substring(c_start,c_end);
    return unescape(c) 
  }
  return ""
}

//## action once window loaded
window.addEventListener('load', function() {
  //# check if authed
  var iden = getCookie(IDENT);
  document.getElementById('login-link').style.display = iden ? 'none' : '';
  document.getElementById('menu-down').style.display = iden ? '' : 'none';
  document.getElementById('profile-link').href = iden ? '/me/p/' + iden : '#';
  //# if show edit link
  var editlink = document.getElementById('edit-link');
  if (editlink) { 
    var omg = getCookie("oMg");
    var check =  omg === 'true';                                                 // for tag|item
    editlink.style.display = check ? '' : 'none';
  }
});

function onSearch(selector, ty) {
  var q = document.getElementById(selector);
  if (q && q.value != "") {
    var openUrl = ty === "g" 
      ? 'https://www.google.com/search?q=site:newdin.com/%20'
      : '/me/item/search?q=';
    window.open(openUrl + q.value, "_blank");
  }
}

// Close the dropdown menu if the user clicks outside of it
window.onclick = function(event) {
  if (!event.target.matches('.toolbtn')) {
    var dropdowns = document.getElementsByClassName("dropdown-content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}