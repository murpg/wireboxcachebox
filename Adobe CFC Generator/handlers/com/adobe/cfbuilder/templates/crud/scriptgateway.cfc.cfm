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


<cfoutput>component output="false"
{

	/* init */
	public any function init()
	{
		var INSTANCE = {};
		INSTANCE.dao = createObject('component', '#settings.file#DAO').init();
		return this;
	}

	/* getAll */
	public #settings.file#[] function getAll()
	{
		var collection = [];
		var obj = '';
		var qry = '';
		var i = 0;
		/* get all records from database */
		var q= new query();
		q.setdatasource(#input.datasource#);
		q.setsql('SELECT * FROM #settings.table#');
		qry=q.execute().getresult();
		/* load value objects */
		for(i=1;i<="##qry.recordcount##";i++)
		{
			obj = createObject('component', '#settings.file#').init();
			<cfloop from="1" to="#arrayLen(settings.field)#" index="i">obj.set#settings.field[i].name#(qry.#settings.field[i].name#[i]);<cfif i LT arrayLen(settings.field)>#linebreak(1)##tab(3)#</cfif></cfloop>
			arrayAppend(collection, obj);
		}
		/* return success */
		return collection;
	}
	
	/* getAll_paged */
	public #settings.file#[] function ngetAll_paged(numeric start,numeric count)
	{
		var collection = [];
		var obj = '';
		var qry = '';
		var i = 0;
		var end=0;
		/* get all records from database */
		var q= new query();
		q.setdatasource(#input.datasource#);
		q.setsql('SELECT * FROM #settings.table#');			
		qry=q.execute().getresult();
		
		/* load value objects */
		if((ARGUMENTS.start + ARGUMENTS.count - 1) GTE qry.recordcount)
			end =  qry.recordcount;
		else
			end= ARGUMENTS.start + ARGUMENTS.count - 1;
		
		for(i="##ARGUMENTS.start##";i<="##end##";i++)
			{
			 obj = createObject('component', '#settings.file#').init();
			<cfloop from="1" to="#arrayLen(settings.field)#" index="i">obj.set#settings.field[i].name#(qry.#settings.field[i].name#[i]);<cfif i LT arrayLen(settings.field)>#linebreak(1)##tab(3)#</cfif></cfloop>
			arrayAppend(collection, obj);
			}
		/* return success */
		return collection;
	}
	
	/* count */
	public numeric function count()
	{
		var qry = "";
		var q=new query();
		q.setdatasource(#input.datasource#);
		q.setsql('SELECT COUNT(#settings.key[1].column#) AS total
			FROM #settings.table#');
		qry=q.execute().getresult();
		return qry.total[1];
	}

}</cfoutput>
<cfsetting enablecfoutputonly="false" />