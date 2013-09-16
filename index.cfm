<cfoutput>#DateFormat( Now(), 'medium' )#</cfoutput><br>
<a href="Reset.cfm">Reset</a>



<cfset obj = application.wirebox.getInstance('CacheBinService').getCachedItems('google-z', 'latestnews') />

<cfloop query="obj.items">
<cfoutput>#obj.items.content[currentrow]#</cfoutput>
</cfloop>
