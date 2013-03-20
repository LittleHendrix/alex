<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UCommentForm.ascx.cs" Inherits="UComment.Usercontrols.AjaxCommentForm" %>
<%@ Import Namespace="UComment.Library" %>

<div id="commentform" class="post-comment">

	<div id="gravatar">&nbsp;</div>

    <div class="form-row">
		<label for="author" class="fieldLabel required">
		   <%= XsltLibrary.Dictionary("#Name", "Name")%>
		</label>
		<input type="text" id="author" name="name" class="input-text required" />
    </div>

    <div class="form-row">
		<label for="email" class="fieldLabel required">
			<%= XsltLibrary.Dictionary("#Email", "Email")%>
		</label>
		<input type="text" id="email" name="email" class="input-text required email" />
    </div>
    
    <div class="form-row">
		<label for="comment" class="fieldLabel required">
		   <%= XsltLibrary.Dictionary("#Comment", "Comment")%>
		</label>
		<textarea id="comment" cols="20" name="comment" rows="7" class="required"></textarea>
    </div>

    <div class="form-row submit">
    	<input type="submit" id="submitButton" class="submit" value="<%= XsltLibrary.Dictionary("#Submit","Post Comment") %>" />
    </div>

</div>

<div id="commentLoading" style="display: none">
    <p><%= XsltLibrary.Dictionary("#CommentLoading", "Posting your comments...")%></p>
</div>

<div id="commentPosted" style="display: none">
    <p><%= XsltLibrary.Dictionary("#CommentPosted", "Your comment has been posted successfully!")%></p>
</div>

<script type="text/javascript">
    jQuery(document).ready(function(){
           
          jQuery("#commentform #email").blur(function(){
                var email = jQuery("#commentform #email").val();
                                
                if(email != ""){
                    var url = "/base/UComment/GetGravatarImage/" + email + "/80.aspx";
                    jQuery.get(url, function(data){
                        if(data != ""){
                             jQuery("#gravatar").css( "background-image","url(" + data + ")" ).show();
                        }else{
                            jQuery("#gravatar").hide();
                        }
                    });
                }
          });
            
          jQuery("form").validate({
          	submitHandler: function(form) {
			    jQuery("#commentform").hide();
			    jQuery("#commentLoading").show();
			    jQuery("#commentform #submit").attr("enabled", false);
			    
			    var url = "/base/UComment/CreateComment/<umbraco:Item field="pageID" runat="server"/>.aspx";
			    
				jQuery.post(url, { author: jQuery("#commentform #author").val(), email: jQuery("#commentform #email").val(), url: jQuery("#commentform #url").val(), comment: jQuery("#commentform #comment").val() },
                   function(data){
                   
                   jQuery("#commentLoading").hide();
                   jQuery("#commentPosted").show().removeClass("error");
                   
                    if(data == 0){
                          jQuery("#commentPosted").addClass("error").html(" <%= XsltLibrary.Dictionary("#CommentFailend","Your comment could not be posted, we're very sorry for the inconvenience") %> ");
                          jQuery("#commentform").show();
                          jQuery("#commentform #submit").attr("enabled", true);
                    }
                    
                   });
			}
			});
    });
</script>