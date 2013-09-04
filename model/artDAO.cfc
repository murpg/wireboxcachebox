﻿<cfcomponent displayname="artDAO" hint="table ID column = ARTID">
<cfproperty name="dsn" inject="ID:myDSN" scope="instance">
	<cffunction name="init" access="public" output="false" returntype="artDAO">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" access="public" output="false" returntype="boolean">
		<cfargument name="art" type="art" required="true" />

		<cfset var qCreate = "" />
		
			<cfquery name="qCreate" datasource="#instance.dsn#">
				INSERT INTO ART
					(
					ARTID, ARTISTID, ARTNAME, DESCRIPTION, PRICE, LARGEIMAGE, MEDIAID, ISSOLD )
				VALUES
					(
					<cfqueryparam value="#arguments.art.getARTID()#" CFSQLType="cf_sql_varchar"  null="#not len(arguments.art.getARTID())#" />, <cfqueryparam value="#arguments.art.getARTISTID()#" CFSQLType="cf_sql_varchar"  />, <cfqueryparam value="#arguments.art.getARTNAME()#" CFSQLType="cf_sql_varchar"  />, <cfqueryparam value="#arguments.art.getDESCRIPTION()#" CFSQLType="cf_sql_clob"  />, <cfqueryparam value="#arguments.art.getPRICE()#" CFSQLType="cf_sql_decimal"  />, <cfqueryparam value="#arguments.art.getLARGEIMAGE()#" CFSQLType="cf_sql_varchar"  />, <cfqueryparam value="#arguments.art.getMEDIAID()#" CFSQLType="cf_sql_varchar"  />, <cfqueryparam value="#arguments.art.getISSOLD()#" CFSQLType="cf_sql_smallint"  /> )
			</cfquery>
		<cfreturn true />
	</cffunction>

	<cffunction name="read" access="public" output="false" returntype="Any">
		<cfargument name="art" type="art" required="true" />

		<cfset var qRead = "" />
		<cfset var strReturn = structNew() />
		
		<cfquery name="qRead" datasource="#instance.dsn#">
			SELECT	ARTID,ARTISTID,ARTNAME,DESCRIPTION,PRICE,LARGEIMAGE,MEDIAID,ISSOLD
			FROM		ART
			WHERE		0=0
			AND		ARTID = <cfqueryparam value="#arguments.art.getARTID()#" CFSQLType="cf_sql_varchar" />
		</cfquery>
	
		<cfif qRead.recordCount>
			<cfset strReturn = queryRowToStruct(qRead)>
			<cfreturn arguments.art.init(argumentCollection=strReturn)>
		</cfif>
	</cffunction>

	<cffunction name="update" access="public" output="false" returntype="boolean">
		<cfargument name="art" type="art" required="true" />

		<cfset var qUpdate = "" />
		<cftry>
			<cfquery name="qUpdate" datasource="#instance.dsn#">
				UPDATE	ART
				SET		ARTISTID = <cfqueryparam value="#arguments.art.getARTISTID()#" CFSQLType="cf_sql_varchar" />, ARTNAME = <cfqueryparam value="#arguments.art.getARTNAME()#" CFSQLType="cf_sql_varchar" />, DESCRIPTION = <cfqueryparam value="#arguments.art.getDESCRIPTION()#" CFSQLType="cf_sql_clob" />, PRICE = <cfqueryparam value="#arguments.art.getPRICE()#" CFSQLType="cf_sql_decimal" />, LARGEIMAGE = <cfqueryparam value="#arguments.art.getLARGEIMAGE()#" CFSQLType="cf_sql_varchar" />, MEDIAID = <cfqueryparam value="#arguments.art.getMEDIAID()#" CFSQLType="cf_sql_varchar" />, ISSOLD = <cfqueryparam value="#arguments.art.getISSOLD()#" CFSQLType="cf_sql_smallint" /> 
				WHERE		0=0
				AND		ARTID = <cfqueryparam value="#arguments.art.getARTID()#" CFSQLType="cf_sql_varchar" />
			</cfquery>
			<cfcatch type="database">
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="boolean">
		<cfargument name="art" type="art" required="true" />

		<cfset var qDelete = "">
		
			<cfquery name="qDelete" datasource="#instance.dsn#">
				DELETE FROM	ART
				WHERE		0=0
				AND		ARTID = <cfqueryparam value="#arguments.art.getARTID()#" CFSQLType="cf_sql_varchar" />
			</cfquery>
		<cfreturn true />
	</cffunction>

	<cffunction name="exists" access="public" output="false" returntype="boolean">
		<cfargument name="art" type="art" required="true" />

		<cfset var qExists = "">
		<cfquery name="qExists" datasource="#instance.dsn#" maxrows="1">
			SELECT count(1) as idexists
			FROM	ART
			WHERE		0=0
			AND		ARTID = <cfqueryparam value="#arguments.art.getARTID()#" CFSQLType="cf_sql_varchar" />
		</cfquery>

		<cfif qExists.idexists>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="boolean" >
		<cfargument name="art" type="art" required="true" >
		
		<cfset var success = false >
		<cfif arguments.art.getARTID() neq 0>
			<cfset success = update(arguments.art) >
		<cfelse>
			<!--- Comment the following if you would NOT like to generate UUID's --->
			<cfset arguments.art.setARTID(createUUID())>
			<cfset success = create(arguments.art) >
		</cfif>
		
		<cfreturn success >
	</cffunction>

	<cffunction name="queryRowToStruct" access="private" output="false" returntype="struct">
		<cfargument name="qry" type="query" required="true">
		
		<cfscript>
			/**
			 * Makes a row of a query into a structure.
			 * 
			 * @param query 	 The query to work with. 
			 * @param row 	 Row number to check. Defaults to row 1. 
			 * @return Returns a structure. 
			 * @author Nathan Dintenfass (nathan@changemedia.com) 
			 * @version 1, December 11, 2001 
			 */
			//by default, do this to the first row of the query
			var row = 1;
			//a var for looping
			var ii = 1;
			//the cols to loop over
			var cols = listToArray(qry.columnList);
			//the struct to return
			var stReturn = structnew();
			//if there is a second argument, use that for the row number
			if(arrayLen(arguments) GT 1)
				row = arguments[2];
			//loop over the cols and build the struct from the query row
			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
				stReturn[cols[ii]] = qry[cols[ii]][row];
			}		
			//return the struct
			return stReturn;
		</cfscript>
	</cffunction>

</cfcomponent>