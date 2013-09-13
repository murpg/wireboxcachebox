<cfoutput>#DateFormat( Now(), "medium" )#</cfoutput><br>
<a href="Reset.cfm">Reset</a>



<cfset obj = application.wirebox.getInstance('CacheBinService').getCachedItems('google-key', 'latestnews') />

<cfloop query="obj.items">
<cfoutput>#obj.items.content[currenrow]#</cfoutput>
</cfloop>
