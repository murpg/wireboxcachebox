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

<cfoutput>component output="false" hint="CFBuilder-Generated:#tableinfo.getCFCName()#"
{
	<cfset entityName = "#tableinfo.getCFCName()#"/>
	/*
	#uCase(tableinfo.getCFCName())# SERVICES
	*/
	
	/* Add #tableinfo.getCFCName()# */
	#tableinfo.getCFCName()# function create#entityName#(#tableinfo.getCFCName()# item)
	{
		/* Auto-generated method
		  Insert a new record in #tableinfo.getCFCName()# */
		entitySave(item);

		/* return created item */
		return item;
	}

	/* Remove #tableinfo.getCFCName()# */
	void function delete#entityName#(<cfloop array="#tableinfo.getPrimaryKeys()#" index="local.ormField">#local.ormField.getCFCFieldName()##tab(1)#</cfloop>)
	{
		/* Auto-generated method
	       Delete a record in the database */
		var primaryKeysMap = {<cfloop from="1" to="#arrayLen(tableinfo.getPrimaryKeys())#" index="j">#tableinfo.getPrimaryKeys()[j].getCFCFieldName()# = #tableinfo.getPrimaryKeys()[j].getCFCFieldName()#<cfif j LT arrayLen(tableinfo.getPrimaryKeys())>,</cfif></cfloop>};
		var item = entityLoad("#tableinfo.getCFCName()#",primaryKeysMap,true);
		if(isNull(item) eq false)
			entityDelete(item);
		
		return;
	}

	/* Get All #tableinfo.getCFCName()# */
	#tableinfo.getCFCName()#[] function getAll#entityName#()
	{
		/* Auto-generated method
		        Retrieve set of records and return them as a query or array */
		/* return items */
		return entityLoad("#tableinfo.getCFCName()#");
	}

	/* Get All Paged #tableinfo.getCFCName()# */
	#tableinfo.getCFCName()#[] function get#entityName#_paged(numeric startIndex,numeric numItems)
	{
		/* Auto-generated method
		         Return a page of numRows number of records as an array or query from the database for this startRow */
		/* return paged items */
		return entityLoad("#tableinfo.getCFCName()#",{},"",{offset=startIndex,maxresults=numItems});
	}

	/* Get #tableinfo.getCFCName()# */
	#tableinfo.getCFCName()# function get#entityName#(<cfloop from="1" to="#arrayLen(tableinfo.getPrimaryKeys())#" index="j"><cfset argName = "#tableinfo.getPrimaryKeys()[j].name#"> #trim(argName)#<cfif j LT arrayLen(tableinfo.getPrimaryKeys())>,#tab(1)#</cfif></cfloop>)
	{
		/* Auto-generated method
		         Retrieve a single record and return it */
		/* return item */
		var primaryKeysMap = {<cfloop from="1" to="#arrayLen(tableinfo.getPrimaryKeys())#" index="j">#tableinfo.getPrimaryKeys()[j].getCFCFieldName()# = #tableinfo.getPrimaryKeys()[j].getCFCFieldName()#<cfif j LT arrayLen(tableinfo.getPrimaryKeys())>,</cfif></cfloop>};
		return entityLoad("#tableinfo.getCFCName()#",primaryKeysMap,true);
	}

	/* Save #tableinfo.getCFCName()# */
	#tableinfo.getCFCName()# function update#entityName#(#tableinfo.getCFCName()# item)
	{
		/* Auto-generated method
		         Update an existing record in the database */
		/* update #tableinfo.getCFCName()# */
		entitySave(item);
		return item;
	}

	/* Count #tableinfo.getCFCName()# */
	numeric function count()
	{
	/* Auto-generated method
		         Return the number of items in your table */
		return ormExecuteQuery("select count(*) from #tableinfo.getCFCName()#",true);
	}

}</cfoutput>
<cfsetting enablecfoutputonly="false" />
</cfprocessingdirective>
