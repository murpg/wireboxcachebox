<cfoutput>#DateFormat( Now(), "medium" )#</cfoutput><br>
<a href="Reset.cfm">Reset</a>
<cfif application.wirebox.getCacheBox().getDefaultCache().lookUp("google-key")>
	yes
	<cfelse>
	no
</cfif>
<cfset cache = application.wirebox.getCacheBox().getDefaultCache()>

<cfif cache.lookUp("google-key")>
	<cfset obj = cache.get("google-key")>
	<cfelse>
	<cfset cache.set("google-key", application.wirebox.getInstance('latestNews'), 60,10)>
	<cfset obj = cache.get("google-key")>
</cfif>

<cfloop query="obj.items">
<cfoutput>#obj.items.content[currentrow]#</cfoutput>
</cfloop>
