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

<cfoutput>component output="false" hint="CFBuilder-Generated:#settings.name#"
{
	/*
           README for sample service

          This generated sample service contains functions that illustrate typical service operations.
          Use these functions as a starting point for creating your own service implementation. Modify the function signatures, 
          references to the database, and implementation according to your needs. Delete the functions that you do not use.
                
          Save your changes and return to Flash Builder. In Flash Builder Data/Services View, refresh the service. 
          Then drag service operations onto user interface components in Design View. For example, drag the getAllItems() operation onto a DataGrid.
                                
          This code is for prototyping only.
          Authenticate the user prior to allowing them to call these methods. You can find more information at http://www.adobe.com/go/cf9_usersecurity

      */


	var INSTANCE = {};
	INSTANCE.com = {};
	
	/* load #settings.name# components */
	INSTANCE.com.#settings.name# = createObject('component', '#settings.file#').init();
	INSTANCE.com.#settings.name#DAO = createObject('component', '#settings.file#DAO').init();
	INSTANCE.com.#settings.name#GATEWAY = createObject('component', '#settings.file#Gateway').init();
	

	/* init */
	function init()
	{
		/* return success */
		return this;
	}

	
	<cfset entityName = settings.name />
	/*
	
	#uCase(settings.name)# SERVICES
	
	*/
	<cfset table = settings />
	/* Create #settings.name# */
	remote #table.name# function create#entityName#(#table.name# item)
	{
		/* Auto-generated method 
		  Insert a new record in #table.name# 
		  Add authorization or any logical checks for secure access to your data */
		idcol=INSTANCE.com.#table.name#DAO.create(<cfloop from="1" to="#arrayLen(table.field)#" index="j">ARGUMENTS.item.get#table.field[j].name#()<cfif j LT arrayLen(table.field)>, </cfif></cfloop>);
		/* return created item */
		return INSTANCE.com.#settings.name#DAO.read(idcol);
	}
	
	
	/* Delete #table.name# */
	remote void function delete#entityName#(<cfloop from="1" to="#arrayLen(table.key)#" index="j">#table.key[j].cftype# #table.key[j].name#<cfif j LT arrayLen(table.key)>,#tab(1)#</cfif></cfloop>)
	{
		
		/* Auto-generated method
		         Delete a record in the database 
				 Add authorization or any logical checks for secure access to your data */
				 
		INSTANCE.com.#table.name#DAO.delete(<cfloop from="1" to="#arrayLen(table.key)#" index="j">ARGUMENTS.#table.key[j].name#<cfif j LT arrayLen(table.key)>,</cfif></cfloop>); 
		/* return success */
		return;
	}
	
	/* Get All #settings.name# */
	remote #table.name#[] function getAll#entityName#()
	{
		/* Auto-generated method
		        Retrieve set of records and return them as a query or array 
				Add authorization or any logical checks for secure access to your data */
		/* return items */		
		return INSTANCE.com.#table.name#Gateway.getAll();
	}
	
	/* Get All Paged #settings.name# */
	remote #table.name#[] function get#entityName#_paged(numeric startIndex,numeric numItems)
	{
		/* Auto-generated method
		         Return a page of numItems number of records as an array or query from the database for this startIndex 
				 Add authorization or any logical checks for secure access to your data */
		/* return paged items */
		return INSTANCE.com.#table.name#Gateway.getAll_paged(ARGUMENTS.startIndex+1, ARGUMENTS.numItems);
	}
	
	/* Get #table.name# */
	remote #table.name# function get#entityName#(<cfloop from="1" to="#arrayLen(table.key)#" index="j">#table.key[j].cftype# #table.key[j].name#<cfif j LT arrayLen(table.key)>,#tab(1)#</cfif></cfloop>)
	{
		
		/* Auto-generated method
		         Retrieve a single record and return it as a query or array 
				 Add authorization or any logical checks for secure access to your data */
		/* return item */
		return INSTANCE.com.#table.name#DAO.read(<cfloop from="1" to="#arrayLen(table.key)#" index="j">ARGUMENTS.#table.key[j].name#<cfif j LT arrayLen(table.key)>,</cfif></cfloop>);
	}
	
	/* Update #table.name# */
	remote #table.name# function update#entityName#(#table.name# item)
	{
		
		/* Auto-generated method
		         Update an existing record in the database 
				 Add authorization or any logical checks for secure access to your data */
		/* update #table.name# */
		INSTANCE.com.#table.name#DAO.update(<cfloop from="1" to="#arrayLen(table.field)#" index="j">ARGUMENTS.item.get#table.field[j].name#()<cfif j LT arrayLen(table.field)>, </cfif></cfloop>); 
		/* return success */
		return ARGUMENTS.item;
	}
	
	
	/* Count #table.name# */
	remote numeric function count()
	{
	/* Auto-generated method
		         Return the number of items in your table 
				 Add authorization or any logical checks for secure access to your data  */
		return INSTANCE.com.#table.name#Gateway.count(); 
	}

}</cfoutput>
<cfsetting enablecfoutputonly="false" />
