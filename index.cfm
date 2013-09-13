<cfoutput>#DateFormat( Now(), "medium" )#</cfoutput><br>
<a href="Reset.cfm">Reset</a>



<cfset obj = application.wirebox.getInstance('CacheBinService').getCachedItems('artGateway-key', 'artGateway') />


<cfdump var="#obj.getByAttributesQuery()#">

<!---<cfloop query="obj.items">
<cfoutput>#obj.items.content[currentrow]#</cfoutput>
</cfloop>--->
