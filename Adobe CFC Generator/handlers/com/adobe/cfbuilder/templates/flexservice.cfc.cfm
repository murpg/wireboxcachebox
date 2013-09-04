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

<cfoutput><:cfcomponent output="false" hint="CFBuilder-Generated:#settings.name#">

	<!--
           README for sample service

          This generated sample service contains functions that illustrate typical service operations.
          Use these functions as a starting point for creating your own service implementation. Modify the function signatures, 
          references to the database, and implementation according to your needs. Delete the functions that you do not use.
                
          Save your changes and return to Flash Builder. In Flash Builder Data/Services View, refresh the service. 
          Then drag service operations onto user interface components in Design View. For example, drag the getAllItems() operation onto a DataGrid.
                                
          This code is for prototyping only.
          Authenticate the user prior to allowing them to call these methods. You can find more information at http://www.adobe.com/go/cf9_usersecurity

      -->


	<:cfset INSTANCE = {} />
	<:cfset INSTANCE.com = {} />
	
	<!-- load #settings.name# components -->
	<:cfset INSTANCE.com.#settings.name# = createObject('component', '#settings.file#').init() />
	<:cfset INSTANCE.com.#settings.name#DAO = createObject('component', '#settings.file#DAO').init() />
	<:cfset INSTANCE.com.#settings.name#GATEWAY = createObject('component', '#settings.file#Gateway').init() />
	

	<!-- init -->
	<:cffunction name="init" returntype="any">
		<!-- return success -->
		<:cfreturn this />
	</:cffunction>

	
	<cfset entityName = settings.name />
	<!--
	
	#uCase(settings.name)# SERVICES
	
	-->
	<cfset table = settings />
	<!-- Create #settings.name# -->
	<:cffunction name="create#entityName#" returntype="#table.name#" access="remote">
		<:cfargument name="item" type="#table.name#" required="true" />
		<!-- Auto-generated method 
		  Insert a new record in #table.name# 
		  Add authorization or any logical checks for secure access to your data -->
		<:cfset idcol=INSTANCE.com.#table.name#DAO.create(<cfloop from="1" to="#arrayLen(table.field)#" index="j">ARGUMENTS.item.get#table.field[j].name#()<cfif j LT arrayLen(table.field)>, </cfif></cfloop>) /> 
		<!-- return created item -->
		<:cfreturn INSTANCE.com.#settings.name#DAO.read(idcol)/>
	</:cffunction>
	
	
	<!-- Delete #table.name# -->
	<:cffunction name="delete#entityName#" returntype="void" access="remote">
		<cfloop from="1" to="#arrayLen(table.key)#" index="j"><:cfargument name="#table.key[j].name#" type="#table.key[j].cftype#" required="true" /><cfif j LT arrayLen(table.key)>#linebreak()##tab(2)#</cfif></cfloop>
		<!-- Auto-generated method
		         Delete a record in the database 
				 Add authorization or any logical checks for secure access to your data -->
				 
		<:cfset INSTANCE.com.#table.name#DAO.delete(<cfloop from="1" to="#arrayLen(table.key)#" index="j">ARGUMENTS.#table.key[j].name#<cfif j LT arrayLen(table.key)>,</cfif></cfloop>) /> 
		<!-- return success -->
		<:cfreturn />
	</:cffunction>
	
	<!-- Get All #settings.name# -->
	<:cffunction name="getAll#entityName#" returntype="#table.name#[]" access="remote">
		<!-- Auto-generated method
		        Retrieve set of records and return them as a query or array 
				Add authorization or any logical checks for secure access to your data -->
		<!-- return items -->		
		<:cfreturn INSTANCE.com.#table.name#Gateway.getAll() />
	</:cffunction>
	
	<!-- Get All Paged #settings.name# -->
	<:cffunction name="get#entityName#_paged" returntype="#table.name#[]" access="remote">
		<:cfargument name="startIndex" type="numeric" required="true" />
		<:cfargument name="numItems" type="numeric" required="true" />
		<!-- Auto-generated method
		         Return a page of numItems number of records as an array or query from the database for this startIndex 
				 Add authorization or any logical checks for secure access to your data -->
		<!-- return paged items -->
		<:cfreturn INSTANCE.com.#table.name#Gateway.getAll_paged(ARGUMENTS.startIndex+1, ARGUMENTS.numItems) />
	</:cffunction>
	
	<!-- Get #table.name# -->
	<:cffunction name="get#entityName#" returntype="#table.name#" access="remote">
		<cfloop from="1" to="#arrayLen(table.key)#" index="j"><:cfargument name="#table.key[j].name#" type="#table.key[j].cftype#" required="true" /><cfif j LT arrayLen(table.key)>#linebreak()##tab(2)#</cfif></cfloop>
		<!-- Auto-generated method
		         Retrieve a single record and return it as a query or array 
				 Add authorization or any logical checks for secure access to your data -->
		<!-- return item -->
		<:cfreturn INSTANCE.com.#table.name#DAO.read(<cfloop from="1" to="#arrayLen(table.key)#" index="j">ARGUMENTS.#table.key[j].name#<cfif j LT arrayLen(table.key)>,</cfif></cfloop>) />
	</:cffunction>
	
	<!-- Update #table.name# -->
		<:cffunction name="update#entityName#" returntype="#table.name#" access="remote">
		<:cfargument name="item" type="#table.name#" required="true" />
		<!-- Auto-generated method
		         Update an existing record in the database 
				 Add authorization or any logical checks for secure access to your data -->
		<!-- update #table.name# -->
		<:cfset INSTANCE.com.#table.name#DAO.update(<cfloop from="1" to="#arrayLen(table.field)#" index="j">ARGUMENTS.item.get#table.field[j].name#()<cfif j LT arrayLen(table.field)>, </cfif></cfloop>) /> 
		<!-- return success -->
		<:cfreturn ARGUMENTS.item/>
	</:cffunction>
	
	
	<!-- Count #table.name# -->
	<:cffunction name="count" returntype="numeric" access="remote">
	<!-- Auto-generated method
		         Return the number of items in your table 
				 Add authorization or any logical checks for secure access to your data  -->
		<:cfreturn INSTANCE.com.#table.name#Gateway.count() /> 
	</:cffunction>

</:cfcomponent></cfoutput>
<cfsetting enablecfoutputonly="false" />
