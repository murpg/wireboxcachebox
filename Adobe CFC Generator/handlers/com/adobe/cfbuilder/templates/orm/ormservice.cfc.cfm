<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
--->
<cfprocessingdirective suppressWhiteSpace = "Yes">
<cfsetting enablecfoutputonly="true" />
<cfparam name="tableinfo"/>

<cflog file="bolt" text="creating service..." />

<cfoutput><:cfcomponent output="false" hint="CFBuilder-Generated:#tableinfo.getCFCName()#">

	<cfset entityName = "#tableinfo.getCFCName()#"/>
	<!--
	#uCase(tableinfo.getCFCName())# SERVICES
	-->
	
	<!-- Add #tableinfo.getCFCName()# -->
	<:cffunction name="create#entityName#" returntype="#tableinfo.getCFCName()#">
		<:cfargument name="item" type="#tableinfo.getCFCName()#" required="true" />
		<!-- Auto-generated method
		  Insert a new record in #tableinfo.getCFCName()# -->
		<:cfset entitySave(item) />

		<!-- return created item -->
		<:cfreturn item/>
	</:cffunction>

	<!-- Remove #tableinfo.getCFCName()# -->
	<:cffunction name="delete#entityName#" returntype="void">
		<cfloop array="#tableinfo.getPrimaryKeys()#" index="local.ormField"><:cfargument name="#local.ormField.getCFCFieldName()#" type="any" required="true" />#linebreak(1)##tab(2)#</cfloop>
		<!-- Auto-generated method
		         Delete a record in the database -->
		<:cfset var primaryKeysMap = {<cfloop from="1" to="#arrayLen(tableinfo.getPrimaryKeys())#" index="j">#tableinfo.getPrimaryKeys()[j].getCFCFieldName()# = #tableinfo.getPrimaryKeys()[j].getCFCFieldName()#<cfif j LT arrayLen(tableinfo.getPrimaryKeys())>,</cfif></cfloop>}>
		<:cfset var item=entityLoad("#tableinfo.getCFCName()#",primaryKeysMap,true)>
		<:cfif isnull(item) eq false>
			<:cfset entityDelete(item) />
		<:/cfif>
		<:cfreturn />
	</:cffunction>

	<!-- Get All #tableinfo.getCFCName()# -->
	<:cffunction name="getAll#entityName#" returntype="#tableinfo.getCFCName()#[]">
		<!-- Auto-generated method
		        Retrieve set of records and return them as a query or array -->
		<!-- return items -->
		<:cfreturn entityLoad("#tableinfo.getCFCName()#") />
	</:cffunction>

	<!-- Get All Paged #tableinfo.getCFCName()# -->
	<:cffunction name="get#entityName#_paged" returntype="#tableinfo.getCFCName()#[]">
		<:cfargument name="startIndex" type="numeric" required="true" />
		<:cfargument name="numItems" type="numeric" required="true" />
		<!-- Auto-generated method
		         Return a page of numRows number of records as an array or query from the database for this startRow -->
		<!-- return paged items -->
		<:cfreturn entityLoad("#tableinfo.getCFCName()#",{},"",{offset=startIndex,maxresults=numItems})/>
	</:cffunction>

	<!-- Get #tableinfo.getCFCName()# -->
	<:cffunction name="get#entityName#" returntype="#tableinfo.getCFCName()#">
		<cfloop from="1" to="#arrayLen(tableinfo.getPrimaryKeys())#" index="j"><cfset argName = "#tableinfo.getPrimaryKeys()[j].name#"> <:cfargument name="#trim(argName)#" type="any" required="true" /><cfif j LT arrayLen(tableinfo.getPrimaryKeys())>#linebreak(1)##tab(2)#</cfif></cfloop>
		<!-- Auto-generated method
		         Retrieve a single record and return it -->
		<!-- return item -->
		<:cfset var primaryKeysMap = {<cfloop from="1" to="#arrayLen(tableinfo.getPrimaryKeys())#" index="j">#tableinfo.getPrimaryKeys()[j].getCFCFieldName()# = #tableinfo.getPrimaryKeys()[j].getCFCFieldName()#<cfif j LT arrayLen(tableinfo.getPrimaryKeys())>,</cfif></cfloop>}>
		<:cfreturn entityLoad("#tableinfo.getCFCName()#",primaryKeysMap,true)>
	</:cffunction>

	<!-- Save #tableinfo.getCFCName()# -->
	<:cffunction name="update#entityName#" returntype="#tableinfo.getCFCName()#">
		<:cfargument name="item" type="#tableinfo.getCFCName()#" required="true" />
		<!-- Auto-generated method
		         Update an existing record in the database -->
		<!-- update #tableinfo.getCFCName()# -->
		<:cfset entitySave(item) />
		<:cfreturn item/>
	</:cffunction>

	<!-- Count #tableinfo.getCFCName()# -->
	<:cffunction name="count" returntype="numeric">
	<!--- Auto-generated method
		         Return the number of items in your table --->
		<:cfreturn ormexEcuteQuery("select count(*) from #tableinfo.getCFCName()#",true)>
	</:cffunction>

</:cfcomponent></cfoutput>
<cfsetting enablecfoutputonly="false" />
</cfprocessingdirective>
