<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfsetting enablecfoutputonly="true" />
<cfparam name="settings" type="struct" default="#structNew()#" />
<cfparam name="input" type="struct" default="#structNew()#" />


<cfoutput><:cfcomponent output="false">

	<!-- init -->
	<:cffunction name="init" returntype="any">
		<:cfset INSTANCE = {} />
		<:cfset INSTANCE.dao = createObject('component', '#settings.file#DAO').init() />
		<:cfreturn this />
	</:cffunction>

	<!-- getAll -->
	<:cffunction name="getAll" returntype="#settings.file#[]">
		<:cfset var collection = [] />
		<:cfset var obj = '' />
		<:cfset var qry = '' />
		<:cfset var i = 0 />
		<!-- get all records from database -->
		<:cfquery name="qry" datasource="#input.datasource#">
			SELECT * FROM #settings.table#
		</:cfquery>
		<!-- load value objects -->
		<:cfloop from="1" to="##qry.recordcount##" index="i">
			<:cfset obj = createObject('component', '#settings.file#').init() />
			<cfloop from="1" to="#arrayLen(settings.field)#" index="i"><:cfset obj.set#settings.field[i].name#(qry.#settings.field[i].name#[i]) /><cfif i LT arrayLen(settings.field)>#linebreak(1)##tab(3)#</cfif></cfloop>
			<:cfset arrayAppend(collection, obj) />
		</:cfloop>
		<!-- return success -->
		<:cfreturn collection />
	</:cffunction>
	
	<!-- getAll_paged -->
	<:cffunction name="getAll_paged" returntype="#settings.file#[]">
		<:cfargument name="start" type="numeric" required="true" />
		<:cfargument name="count" type="numeric" required="true" />
		<:cfset var collection = [] />
		<:cfset var obj = '' />
		<:cfset var qry = '' />
		<:cfset var i = 0 />
		<:cfset var end=0 />
		<!-- get all records from database -->
		<:cfquery name="qry" datasource="#input.datasource#">
			SELECT * FROM #settings.table#			
		</:cfquery>
		<!-- load value objects -->
		<:cfif (ARGUMENTS.start + ARGUMENTS.count - 1) GTE qry.recordcount >
			<:cfset end =  qry.recordcount />
		<:cfelse>
			<:cfset end= ARGUMENTS.start + ARGUMENTS.count - 1 />
		</:cfif>
		<:cfloop from="##ARGUMENTS.start##" to="##end##" index="i">
			<:cfset obj = createObject('component', '#settings.file#').init() />
			<cfloop from="1" to="#arrayLen(settings.field)#" index="i"><:cfset obj.set#settings.field[i].name#(qry.#settings.field[i].name#[i]) /><cfif i LT arrayLen(settings.field)>#linebreak(1)##tab(3)#</cfif></cfloop>
			<:cfset arrayAppend(collection, obj) />
		</:cfloop>
		<!-- return success -->
		<:cfreturn collection />
	</:cffunction>
	
	<!-- count -->
	<:cffunction name="count" returntype="numeric">
		<:cfset var qry = "" />
		<:cfquery name="qry" datasource="#input.datasource#">
			SELECT COUNT(#settings.key[1].column#) AS total
			FROM #settings.table#
		</:cfquery>
		<:cfreturn qry.total[1] />
	</:cffunction>

</:cfcomponent></cfoutput>
<cfsetting enablecfoutputonly="false" />