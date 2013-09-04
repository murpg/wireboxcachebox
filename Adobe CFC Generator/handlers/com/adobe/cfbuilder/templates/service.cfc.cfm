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

<cflog file="bolt" text="creating service..." />

<cfoutput><:cfcomponent output="false">

	<:cfset INSTANCE = {} />
	<:cfset INSTANCE.com = {} />
	<cfloop from="1" to="#arrayLen(settings.table)#" index="i">
	<!-- load #settings.table[i].name# components -->
	<:cfset INSTANCE.com.#settings.table[i].name# = createObject('component', '#settings.table[i].file#').init() />
	<:cfset INSTANCE.com.#settings.table[i].name#DAO = createObject('component', '#settings.table[i].file#DAO').init() />
	<:cfset INSTANCE.com.#settings.table[i].name#GATEWAY = createObject('component', '#settings.table[i].file#Gateway').init() />
	</cfloop>

	<!-- init -->
	<:cffunction name="init" returntype="any">
		<!-- return success -->
		<:cfreturn this />
	</:cffunction>

	<cfloop from="1" to="#arrayLen(settings.table)#" index="i">
	<cfif arrayLen(settings.table) EQ 1><cfset entityName = "Item"/><cfelse><cfset entityName = settings.table[i].name /></cfif>
	<!--
	
	#uCase(settings.table[i].name)# SERVICES
	
	-->
	<cfset table = settings.table[i] />
	<!-- Add #settings.table[i].name# -->
	<:cffunction name="add#entityName#" returntype="void" access="remote">
		<cfloop from="1" to="#arrayLen(table.field)#" index="j"><cfif !table.field[j].isPrimaryKey><:cfargument name="#table.field[j].name#" type="#table.field[j].cftype#" required="true" /><cfif j LT arrayLen(table.field)>#linebreak(1)##tab(2)#</cfif></cfif></cfloop>
		<!-- create new #table.name# -->
		<:cfset INSTANCE.com.#table.name#DAO.create(<cfloop from="1" to="#arrayLen(table.field)#" index="j"><cfif !table.field[j].isPrimaryKey>ARGUMENTS.#table.field[j].name#<cfif j LT arrayLen(table.field)>, </cfif></cfif></cfloop>) /> 
		<!-- return success -->
		<:cfreturn />
	</:cffunction>
	
	<!-- Remove #table.name# -->
	<:cffunction name="remove#entityName#" returntype="void" access="remote">
		<cfloop from="1" to="#arrayLen(table.key)#" index="j"><:cfargument name="#table.key[j].name#" type="#table.key[j].cftype#" required="true" /><cfif j LT arrayLen(table.key)>#linebreak(1)##tab(2)#</cfif></cfloop>
		<!-- delete #table.name# -->
		<:cfset INSTANCE.com.#table.name#DAO.delete(<cfloop from="1" to="#arrayLen(table.key)#" index="j">ARGUMENTS.#table.key[j].name#<cfif j LT arrayLen(table.key)>,</cfif></cfloop>) /> 
		<!-- return success -->
		<:cfreturn />
	</:cffunction>
	
	<!-- Get All #settings.table[i].name# -->
	<:cffunction name="getAll#entityName#" returntype="#table.name#[]" access="remote">
		<!-- get all #table.name# --> 
		<:cfreturn INSTANCE.com.#table.name#Gateway.getAll() />
	</:cffunction>
	
	<!-- Get All Paged #settings.table[i].name# -->
	<:cffunction name="getAll#entityName#_paged" returntype="#table.name#[]" access="remote">
		<:cfargument name="startIndex" type="numeric" required="true" />
		<:cfargument name="numItems" type="numeric" required="true" />
		<!-- get all #table.name# --> 
		<:cfreturn INSTANCE.com.#table.name#Gateway.getAll_paged(ARGUMENTS.startIndex, ARGUMENTS.numItems) />
	</:cffunction>
	
	<!-- Get #table.name# -->
	<:cffunction name="get#entityName#" returntype="#table.name#" access="remote">
		<cfloop from="1" to="#arrayLen(table.key)#" index="j"><:cfargument name="#table.key[j].name#" type="#table.key[j].cftype#" required="true" /><cfif j LT arrayLen(table.key)>#linebreak(1)##tab(2)#</cfif></cfloop>
		<!-- return success -->
		<:cfreturn INSTANCE.com.#table.name#DAO.read(<cfloop from="1" to="#arrayLen(table.key)#" index="j">ARGUMENTS.#table.key[j].name#<cfif j LT arrayLen(table.key)>,</cfif></cfloop>) />
	</:cffunction>
	
	<!-- Save #table.name# -->
	<:cffunction name="save#entityName#" returntype="void" access="remote">
		<cfloop from="1" to="#arrayLen(table.field)#" index="j"><:cfargument name="#table.field[j].name#" type="#table.field[j].cftype#" required="true" /><cfif j LT arrayLen(table.field)>#linebreak(1)##tab(2)#</cfif></cfloop>
		<!-- update #table.name# -->
		<:cfset INSTANCE.com.#table.name#DAO.update(<cfloop from="1" to="#arrayLen(table.field)#" index="j">ARGUMENTS.#table.field[j].name#<cfif j LT arrayLen(table.field)>, </cfif></cfloop>) /> 
		<!-- return success -->
		<:cfreturn />
	</:cffunction>
	</cfloop>
	
	<!-- Count #table.name# -->
	<:cffunction name="count#entityName#" returntype="numeric" access="remote">
		<:cfreturn INSTANCE.com.#table.name#Gateway.count() /> 
	</:cffunction>

</:cfcomponent></cfoutput>
<cfsetting enablecfoutputonly="false" />