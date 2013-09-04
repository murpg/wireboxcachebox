<cflock timeout="0" name="ORMExtLock">
	<cfheader name="Content-Type" value="text/xml">

	<cfif not structKeyExists(application,"refreshList")>
		<cfoutput>
	    <response showresponse="false">
		</response>
		</cfoutput>
        <cfabort>
	</cfif>

 	<cfif not structKeyExists(application,"ormExtUtil")>
        <cfset application.ormExtUtil = createObject("component","framework.util")>
	</cfif>

	<cfoutput >
	    <response showresponse="false">
	    	<ide>
		    	<commands>
		    		<cfloop array="#application.refreshList#" index="path">
		    		    #application.ormExtUtil.createRefreshFolderCommand(path)#
		    		</cfloop>
		    	</commands>
			</ide>
	    </response>
		<cfset arrayClear(application.refreshList)>
	</cfoutput>
</cflock>