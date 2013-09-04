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
	/* Auto-generated method
		         Add authroization or any logical checks for secure access to your data */
	/* init */
	public any function init()
	{
			return this ;
	}
	
	/* create */
	public any function create(<cfloop from="1" to="#arrayLen(settings.field)#" index="i">#settings.field[i].cftype# #settings.field[i].column#<cfif i neq arraylen(settings.field)>,</cfif> </cfloop>)
	{
				
		/* Auto-generated method
		         Add authroization or any logical checks for secure access to your data */
		var IdentityCol="";
		var qry="";	
		/*TODO:  Below code is for table without auto increment enabled for primary key .Change the query Appropriately*/
		/* insert record */
		var q =new query();
		q.setdataSource(#input.datasource#);
		q.setsql('INSERT INTO #settings.name#
			(
				<cfloop from="1" to="#arrayLen(settings.field)#" index="i">#lCase(settings.field[i].column)#<cfif i NEQ arrayLen(settings.field)>,</cfif><cfif NOT i mod 5>#linebreak(1)##tab(4)#</cfif></cfloop>
			)
			VALUES
			(
				<cfloop from="1" to="#arrayLen(settings.field)#" index="i">##ARGUMENTS.#settings.field[i].column###<cfif i NEQ arrayLen(settings.field)>,#linebreak(1)##tab(4)#</cfif></cfloop>
			)');
		var r=q.execute().getresult();
		
		<cfset pset="false">
		<cfloop from="1" to="#arrayLen(settings.field)#" index="i">
			<cfif settings.field[i].isprimarykey >
		if(arguments.#settings.field[i].column# NEQ '')
			IdentityCol=arguments.#settings.field[i].column#;
					<cfset pset="true">
				<cfbreak>
			</cfif>
		</cfloop>
	  	<cfif pset EQ "false">
	  	  if(arguments.#settings.field[1].column# NEQ '')
	  		IdentityCol="arguments.#settings.field[1].column#";
		</cfif>      
		 else
		 {
		/*TODO: This logic is for diffrent db's.Delete the conditions not applicable */	 
      	 if(IsDefined("qry.GENERATEDKEY"))
            identityCol = qry.GENERATEDKEY;
		 else if(IsDefined("qry.IDENTITYCOL"))/* SQL Server only*/	
            identityCol = qry.IDENTITYCOL;
      	 else if(IsDefined("qry.GENERATED_KEY")) /* MySQL only*/
            identityCol = qry.GENERATED_KEY;
      	 else if(IsDefined("qry.GENERATED_KEYS"))
            identityCol = qry.GENERATED_KEYS;
      	 else if(IsDefined("qry.ROWID"))/* Oracle only */
            identityCol = qry.ROWID;
      	 else if(IsDefined("qry.SYB_IDENTITY"))/* Sybase only */
            identityCol = qry.SYB_IDENTITY;
      	 else if(IsDefined("qry.SERIAL_COL")) /*Informix only*/
            identityCol = qry.SERIAL_COL;
      	 else if(IsDefined("qry.KEY_VALUE"))
            identityCol = qry.KEY_VALUE;
      	
		
	  	}	
		/* return IdentityCol */
		return IdentityCol;
	}
	
	
	/* read */
	public #settings.file# function read(id)
	    {
		
		/* Auto-generated method
		         Add authroization or any logical checks for secure access to your data */
		var obj = createObject('component', '#settings.file#').init();
		var i = 1;
		var qry="";
		<cfset firstKey = true />
		var q= new query();
		q.setdatasource(#input.datasource#);
		q.setsql('SELECT <cfloop from="1" to="#arrayLen(settings.field)#" index="i">#lCase(settings.field[i].column)#<cfif i NEQ arrayLen(settings.field)>,</cfif><cfif NOT i mod 5>#linebreak(1)##tab(5)#</cfif></cfloop>
			FROM #settings.name#
			where <cfloop from="1" to="#arrayLen(settings.key)#" index="i"><cfif !firstKey>#linebreak(1)##tab(4)#AND </cfif>#lCase(settings.key[i].column)# = "##ARGUMENTS.id##"'<cfset firstKey = "true" /></cfloop>);
		qry=q.execute().getresult();	
		/* load value object */
		<cfloop from="1" to="#arrayLen(settings.field)#" index="i">obj.set#settings.field[i].column#(qry.#settings.field[i].column#[i]);
		</cfloop>/* return success */
		return obj;
	    }
	
	/* update */
	public void function update(<cfloop from="1" to="#arrayLen(settings.field)#" index="i">#settings.field[i].cftype# #settings.field[i].column##iif(i LT arrayLen(settings.field), de(',' & tab(1)), de(''))#</cfloop>)
		{
		/* Auto-generated method
		         Add authroization or any logical checks for secure access to your data */
		<cfset firstKey = true />
		var qry="";
		/* update database */
		var q =new query();
		q.setdatasource(#input.datasource#);
		q.setsql('UPDATE #settings.name#
			SET <cfloop from="1" to="#arrayLen(settings.field)#" index="i"><cfif !settings.field[i].isPrimaryKey>#lCase(settings.field[i].column)# = "##ARGUMENTS.#settings.field[i].column###" <cfif i NEQ arrayLen(settings.field)>,#linebreak(1)##tab(4)#</cfif></cfif></cfloop>
			WHERE <cfloop from="1" to="#arrayLen(settings.key)#" index="i"><cfif !firstKey>#linebreak(1)##tab(4)#AND </cfif>#lCase(settings.key[i].column)# = "##ARGUMENTS.#settings.key[i].column###" '<cfset firstKey = "true" /></cfloop>);
	    qry=q.execute().getresult();		
		
		
		}
	
	/* delete */
	public void function delete(<cfset firstKey = true /><cfloop from="1" to="#arrayLen(settings.field)#" index="i"><cfif settings.field[i].isPrimaryKey><cfif !firstKey>#linebreak(1)##tab(2)#</cfif>#settings.field[i].cftype# #settings.field[i].column#<cfset firstKey = "true" /></cfif></cfloop>)
		{
		/* Auto-generated method
		         Add authroization or any logical checks for secure access to your data */
		var qry="";
		/* delete from database */
		var q =new query();
		q.setdatasource("#input.datasource#");
		q.setsql('DELETE FROM #settings.name#
			WHERE <cfloop from="1" to="#arrayLen(settings.key)#" index="i"><cfif !firstKey>#linebreak(1)##tab(4)#AND </cfif>#lCase(settings.key[i].column)# = "##ARGUMENTS.#settings.key[i].column###"' <cfset firstKey = "true" /></cfloop>);
		qry=q.execute().getresult();
		
		}

}</cfoutput>
<cfsetting enablecfoutputonly="false" />