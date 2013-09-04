<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="RDSInfo" output="false" >

	<cfset this.databaseName = "">
	<cfset this.tables = ArrayNew(1)>

	<cffunction name="setDatabaseName" output="false">
		<cfargument name="dbName" required="true" >
		
		<cfset this.databaseName = arguments.dbName>
	</cffunction>	
	
	<cffunction name="getDatabaseName" output="false">
		<cfreturn this.databaseName>
	</cffunction>
	

	<cffunction name="addTable" output="false">
		<cfargument name="table" required="true" type="TableInfo">
		
		<cfset ArrayAppend(this.tables,table)>	
    </cffunction>
	
	<cffunction name="getTables" returntype="array" output="false">
		<cfreturn this.tables>
	</cffunction>
		
</cfcomponent>