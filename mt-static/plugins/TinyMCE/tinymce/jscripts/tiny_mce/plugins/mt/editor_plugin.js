(function(b){function a(d,c){b.fn.mtDialog.open(ScriptURI+"?__mode="+d+"&amp;"+c)}tinymce.Editor.prototype.addMtButton=function(e,f){var d=this;var g={};var c=f.onclickFunctions;if(c){f.onclick=function(){var i=d.mtEditorStatus.mode;var h=c[i];if(typeof(h)=="string"){d.mtProxies[i].execCommand(h)}else{h.apply(d,arguments)}if(i=="source"){d.onMTSourceButtonClick.dispatch(d,d.controlManager)}};for(k in c){g[k]=1}}else{g={wysiwyg:1,source:1}}if(!f.isSupported){f.isSupported=function(j,i){if(!g[j]){return false}if(c&&j=="source"){var h=c[j];if(typeof(h)=="string"){return d.mtProxies.source.isSupported(h,i)}else{return true}}else{return true}}}if(typeof(d.mtButtons)=="undefined"){d.mtButtons={}}d.mtButtons[e]=f;return d.addButton(e,f)};tinymce.ScriptLoader.add(tinymce.PluginManager.urls.mt+"/langs/en.js");tinymce.create("tinymce.plugins.MovableType",{init:function(l,c){tinymce.DOM.loadCSS(c+"/css/mt.css");var d=l.id;var i=b("#blog-id").val()||0;var j={};var e=[];var g={};function m(p,o){var n=p+"-"+o;if(!g[n]){g[n]={};b.each(l.mtButtons,function(q,r){if(r.isSupported(p,o)){g[n][q]=r}})}return g[n]}l.mtProxies=j;l.mtEditorStatus={mode:"wysiwyg",format:"richtext"};l.addCommand("mtGetStatus",function(){return l.mtEditorStatus});l.addCommand("mtSetStatus",function(n){var o=l.mtEditorStatus;b.extend(o,n);b.each(e,function(){l.controlManager.setDisabled(this,false)});e=[];if(o.mode=="source"){j.source.setFormat(o.format);var p={};b.each(m(o.mode,o.format),function(r,q){p[d+"_"+r]=1});b.each(l.controlManager.controls,function(q,r){if(!r.disabled&&!p[q]){l.controlManager.setDisabled(q,true);e.push(q)}})}});l.addCommand("mtGetProxies",function(){return j});l.addCommand("mtSetProxies",function(n){b.extend(j,n)});l.addMtButton("mt_font_size_smaller",{title:"mt.font_size_smaller",onclickFunctions:{wysiwyg:"fontSizeSmaller",source:"fontSizeSmaller"}});l.addMtButton("mt_font_size_larger",{title:"mt.font_size_larger",onclickFunctions:{wysiwyg:"fontSizeLarger",source:"fontSizeLarger"}});l.addMtButton("mt_bold",{title:"mt.bold",onclickFunctions:{wysiwyg:function(){l.execCommand("bold")},source:"bold"}});l.addMtButton("mt_italic",{title:"mt.italic",onclickFunctions:{wysiwyg:function(){l.execCommand("italic")},source:"italic"}});l.addMtButton("mt_underline",{title:"mt.underline",onclickFunctions:{wysiwyg:function(){l.execCommand("underline")},source:"underline"}});l.addMtButton("mt_strikethrough",{title:"mt.strikethrough",onclickFunctions:{wysiwyg:function(){l.execCommand("strikethrough")},source:"strikethrough"}});l.addMtButton("mt_insert_link",{title:"mt.insert_link",onclickFunctions:{wysiwyg:function(){var o=l.dom.getParent(l.selection.getNode(),"A");var n=!l.selection.isCollapsed();j.wysiwyg.execCommand("insertLink",null,{anchor:o,textSelected:n})},source:"insertLink"}});l.addMtButton("mt_insert_email",{title:"mt.insert_email",onclickFunctions:{wysiwyg:function(){var o=l.dom.getParent(l.selection.getNode(),"A");var n=!l.selection.isCollapsed();j.wysiwyg.execCommand("insertEmail",null,{anchor:o,textSelected:n})},source:"insertEmail"}});l.addMtButton("mt_indent",{title:"mt.indent",onclickFunctions:{wysiwyg:function(){l.execCommand("indent")},source:"indent"}});l.addMtButton("mt_outdent",{title:"mt.outdent",onclickFunctions:{wysiwyg:function(){l.execCommand("outdent")}}});l.addMtButton("mt_insert_unordered_list",{title:"mt.insert_unordered_list",onclickFunctions:{wysiwyg:function(){l.execCommand("insertUnorderedList")},source:"insertUnorderedList"}});l.addMtButton("mt_insert_ordered_list",{title:"mt.insert_ordered_list",onclickFunctions:{wysiwyg:function(){l.execCommand("insertOrderedList")},source:"insertOrderedList"}});l.addMtButton("mt_justify_left",{title:"mt.justify_left",onclickFunctions:{wysiwyg:function(){l.execCommand("justifyLeft")},source:"justifyLeft"}});l.addMtButton("mt_justify_center",{title:"mt.justify_center",onclickFunctions:{wysiwyg:function(){l.execCommand("justifyCenter")},source:"justifyCenter"}});l.addMtButton("mt_justify_right",{title:"mt.justify_right",onclickFunctions:{wysiwyg:function(){l.execCommand("justifyRight")},source:"justifyRight"}});l.addMtButton("mt_insert_image",{title:"mt.insert_image",onclick:function(){a("dialog_list_asset","_type=asset&amp;edit_field="+d+"&amp;blog_id="+i+"&amp;dialog_view=1&amp;filter=class&amp;filter_val=image")}});l.addMtButton("mt_insert_file",{title:"mt.insert_file",onclick:function(){a("dialog_list_asset","_type=asset&amp;edit_field="+d+"&amp;blog_id="+i+"&amp;dialog_view=1")}});l.addMtButton("mt_source_bold",{title:"mt.bold",onclickFunctions:{source:"bold"}});l.addMtButton("mt_source_italic",{title:"mt.italic",onclickFunctions:{source:"italic"}});l.addMtButton("mt_source_blockquote",{title:"mt.blockquote",onclickFunctions:{source:"blockquote"}});l.addMtButton("mt_source_unordered_list",{title:"mt.insert_unordered_list",onclickFunctions:{source:"insertUnorderedList"}});l.addMtButton("mt_source_ordered_list",{title:"mt.insert_ordered_list",onclickFunctions:{source:"insertOrderedList"}});l.addMtButton("mt_source_list_item",{title:"mt.list_item",onclickFunctions:{source:"insertListItem"}});l.addMtButton("mt_source_mode",{title:"mt.source_mode",onclickFunctions:{wysiwyg:function(){l.execCommand("mtSetFormat","none.tinymce_temp")},source:function(){l.execCommand("mtSetFormat","richtext")}}});var f={mt_bold:"bold",mt_italic:"italic",mt_underline:"underline",mt_strikethrough:"strikethrough",mt_insert_link:"link",mt_justify_left:"justifyleft",mt_justify_center:"justifycenter",mt_justify_right:"justifyright"};l.onNodeChange.add(function(q,o,v,u,p){var r=q.mtEditorStatus;if(r.mode=="wysiwyg"){b.each(f,function(s,n){o.setActive(s,q.queryCommandState(n))});o.setDisabled("mt_outdent",!q.queryCommandState("Outdent"))}if(q.getParam("fullscreen_is_enabled")){o.setDisabled("mt_source_mode",true)}else{if(q.mtEditorStatus.mode=="source"&&q.mtEditorStatus.format!="none.tinymce_temp"){b("#"+d+"_mt_source_mode").hide()}else{b("#"+d+"_mt_source_mode").show()}var t=q.mtEditorStatus.mode=="source"&&q.mtEditorStatus.format=="none.tinymce_temp";o.setActive("mt_source_mode",t)}if(!q.mtProxies.source){return}b.each(h,function(n,s){o.setActive(n,q.mtProxies.source.isStateActive(s))})});if(!l.onMTSourceButtonClick){l.onMTSourceButtonClick=new tinymce.util.Dispatcher(l)}var h={mt_source_bold:"bold",mt_source_italic:"italic",mt_source_blockquote:"blockquote",mt_source_unordered_list:"insertUnorderedList",mt_source_ordered_list:"insertOrderedList",mt_source_list_item:"insertListItem"};l.onMTSourceButtonClick.add(function(o,n){b.each(h,function(p,q){n.setActive(p,o.mtProxies.source.isStateActive(q))})})},getInfo:function(){return{longname:"MovableType",author:"Six Apart, Ltd",authorurl:"",infourl:"",version:tinymce.majorVersion+"."+tinymce.minorVersion}}});tinymce.PluginManager.add("mt",tinymce.plugins.MovableType)})(jQuery);