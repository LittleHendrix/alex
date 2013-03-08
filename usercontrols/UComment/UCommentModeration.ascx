<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UCommentModeration.ascx.cs" Inherits="UComment.Dashboard.UCommentModeration" %>
<%@ Register Namespace="umbraco.uicontrols" Assembly="controls" TagPrefix="umb" %>

<style type="text/css">
    
.comment-select
{
	float:left;

}
.comment-gravatar
{
	float:left;
	margin-right:8px;
}
.comment-actions
{
	float:right;
	width: 150px;
}
.comment-data
{
    margin-left: 30px;
}
#comments-options
{
	margin-top:5px;
	padding:5px;
}

 #comments-paging
 {
 	padding:5px;
 }

.comment
{
	padding-top:5px;
	padding-left:5px;
	border-bottom: solid 1px #CCCCCC;
}
.spamTrue
{
	background-color: #FFFFE0;
}

#bulkactions
{
	float:right;
}
</style>

<script type="text/javascript" language="javascript">
    function commentconfirm_delete() {
        if (confirm("Are you sure you want to delete this comment?") == true)
            return true;
        else
            return false;
    }
</script>

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
<ContentTemplate>

<umb:Pane runat="server" Text="Comment moderation">    
<div id="comments-options">

<div id="bulkactions">
<asp:LinkButton ID="btnDeleteSelected" runat="server" onclick="BtnDeleteSelectedClick">Delete Selected</asp:LinkButton>
</div>



<asp:LinkButton ID="btnApproved" runat="server" onclick="BtnApprovedClick">Approved</asp:LinkButton> | 
<asp:LinkButton ID="btnSpam" runat="server" onclick="BtnSpamClick">Spam</asp:LinkButton> | 
<asp:LinkButton ID="btnAll" runat="server" onclick="BtnAllClick">All</asp:LinkButton>


</div>

<div id="comments">
<asp:Repeater ID="rptComments" runat="server">
    <ItemTemplate>
        <div class='comment spam<%# Eval("spam") %>'>
        
            <asp:Label ID="lblID" runat="server" Text='<%# Eval("id") %>' Visible="false"></asp:Label>
            
            <div class="comment-actions">
                <asp:LinkButton ID="btnDelete" runat="server" CommandArgument='<%# Eval("id") %>' OnClientClick="return commentconfirm_delete();" OnClick="BtnDeleteClick">Delete</asp:LinkButton>
                | <asp:LinkButton ID="btnToggleState" runat="server" CommandName='<%# Eval("spam").ToString() %>' CommandArgument='<%# Eval("id") %>' Text='<%# GetToggleStateText(Eval("spam")) %>' OnClick="BtnToggleStateClick"></asp:LinkButton>
            </div>
            
             <div class="comment-select">
                         <asp:CheckBox ID="cbSelectComment" runat="server" />
             </div>
                    
            <div class="comment-data">
                <p class="comment-author">
                
                   
            
                    <div class="comment-gravatar">
                        <img src='http://www.gravatar.com/avatar/<%# umbraco.library.md5(Eval("email").ToString()) %>?s=32' width="32" height="32" alt="avatar" />
                    </div>
                    <strong><%# Eval("name") %></strong>
                    <br/>
                    <a href='<%# Eval("website") %>' target='_blank'><%# Eval("website") %></a> | <a href='mailto:<%# Eval("email") %>'><%# Eval("email") %></a>
                </p>
                <p>
                 <%# Eval("comment").ToString().Replace("\n","<br/>") %>
                </p>
                <p>
                 On  <%# GetPageDetails(Eval("nodeid")) %> , <%# Eval("created") %>
                </p>
            </div>
            

            
            <br style="clear:both;" />
                
        </div>
    </ItemTemplate>
</asp:Repeater>
<div id="comments-paging">

    <asp:Repeater ID="rptPages" runat="server">
        <ItemTemplate>
        
        <asp:LinkButton ID="btnPage"
                         CommandName="Page"
                         CommandArgument="<%#Container.DataItem %>"
                         CssClass="text"
                         Runat="server"><%# Container.DataItem %>
                         </asp:LinkButton>
        </ItemTemplate>
                         
    </asp:Repeater>

</div>
</div>
</umb:Pane>

</ContentTemplate>
</asp:UpdatePanel>