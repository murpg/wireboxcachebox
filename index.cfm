<cfoutput>#DateFormat( Now(), "medium" )#</cfoutput><br>
<a href="Reset.cfm">Reset</a>
<cfset cache = application.wirebox.getCacheBox().getDefaultCache()>

<cfif cache.lookUp("google-key")>
	<cfset obj = cache.get("google-key")>
	<cfelse>
	<cfset cache.set("google-key", application.wirebox.getInstance('latestNews'), 60,10)>
	<cfset obj = cache.get("google-key")>
</cfif>

<cfoutput>#obj.items.content[2]#</cfoutput>
