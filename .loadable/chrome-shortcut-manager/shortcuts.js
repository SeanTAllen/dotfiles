// ==UserScript==
// @ShortcutManager
// @name Save to Pinboard Read Later
// @namespace IclOUDymAJGD
// @key Alt+Shift+l
// @include *
// ==/UserScript==
q=location.href;p=document.title;void(t=open('https://pinboard.in/add?later=yes&noui=yes&jump=close&url='+encodeURIComponent(q)+'&title='+encodeURIComponent(p),'Pinboard','toolbar=no,width=100,height=100'));t.blur();

// ==UserScript==
// @ShortcutManager
// @name Open Pinbaord Unread
// @namespace IclOUDymAJGD
// @key Alt+Shift+u
// @include *
// @execute OpenAPage(["https://pinboard.in/u:seantallen/unread/"])
// ==/UserScript==

// ==UserScript==
// @ShortcutManager
// @name Add to Pinboard
// @namespace IclOUDymAJGD
// @key Alt+Shift+a
// @include *
// ==/UserScript==
javascript:q=location.href;if(document.getSelection){d=document.getSelection();}else{d='';};p=document.title;void(open('https://pinboard.in/add?showtags=yes&url='+encodeURIComponent(q)+'&description='+encodeURIComponent(d)+'&title='+encodeURIComponent(p),'Pinboard','toolbar=no,width=700,height=600'));
