<cfparam name="form.data" >
<cfparam name="Session.ormTables">

<cfset sessionTables = Session.ormTables>
<cfset oldOrmSessionTables = sessionTables>
<cfset ormTableCount = sessionTables.size()>

<cftry>
		<cfset tables = deserializeJSON(form.data)>
		<cfset jsonTablesSt = structNew()>
		
		<cfloop array="#tables#" index="table">
		    <cfset jsonTablesSt[table.name] = table>
		</cfloop>
		
		<cfloop array="#Session.ormTables#" index="table" >
		    <cfif structKeyExists(jsonTablesSt,table.TABLENAME) eq false>
		        <cfset arrayDelete(Session.ormTables,table)>
		        <cfcontinue>
		    </cfif>
		    <cfset jsonTable = jsonTablesSt[table.TABLENAME]>
		     <cfset syncTable(table,jsonTable)>
		</cfloop>
		
		<cfinclude template="generateORMSample.cfm" >
        
        <cflock name="ORMExtLock" timeout="0" >
        	<cfif not structKeyExists(application,"refreshList")>
                <cfset application.refreshList = arrayNew(1)>
        	</cfif>    
        	<cfset arrayAppend(application.refreshList,session.ormMgr.getLocation())>
        </cflock>
    <cfcatch >
        <cflog file="bolt" type="error" text="#CFCATCH.Message#" />
        <cfoutput >
            Error : #CFCATCH.Message#
        </cfoutput>
        <cfabort >
    </cfcatch>
	<cffinally>
		<cfset  Session.ormTables =  oldOrmSessionTables>
	</cffinally>
	
</cftry>




<cffunction name="syncTable">
    <cfargument name="sessionTable" required="true" type="framework.ORMTable" >
    <cfargument name="table" required="true" type="struct" >
    
    <cfset sessionTable.restTalbeForCodeGeneration()>
    
    <cfset arguments.sessionTable.setCFCName(arguments.table.cfcName)>
    <cfloop array="#arguments.table.cols#" index="col">
        <cfset var sessionCol = sessionTable.getField(col.name)>
        <cfif isSimpleValue(sessionCol)>
            <cfcontinue>
        </cfif>
        <cfset syncField(sessionCol,col)>
    </cfloop> 
    
    <cfloop array="#arguments.table.relations#" index="relation">
        <cfset createTableRelationship(arguments.sessionTable,relation)>
    </cfloop>
    
</cffunction>

<cffunction name="syncField">
	<cfargument name="sessionField" required="true" type="framework.ORMField" >
    <cfargument name="field" required="true" type="struct"  >
    
     <cfset arguments.sessionField.setSelected(arguments.field.isSelected)>
     <cfset arguments.sessionField.setCFCFieldName(arguments.field.propertyName)>
     <cfset arguments.sessionField.setCFCFieldType(arguments.field.propertyType)>
     <cfset arguments.sessionField.setPrimaryKey(arguments.field.isPrimaryKey)>
</cffunction>

<cffunction name="createTableRelationship">
	<cfargument name="sessionTable" required="true" type="framework.ORMTable" >
    <cfargument name="relationship" required="true" type="struct" >
    
    <cfset var isSrcRelation = true> 
    <cfset var tableName = arguments.sessionTable.getTableName()>
    <cfset var newRelation =  createObject("component","framework.ORMRelation" )>
    
    <cfif tableName eq arguments.relationship.srcTable>
        <cfif arguments.relationship.srcRelEnabled eq false>
            <cfreturn>
        </cfif>
        <cfset isSrcRelation = true>
		<cfset newRelation.setRelationName(arguments.relationship.srcRelName)>
		<cfset newRelation.setTargetTable(arguments.relationship.targetTable)>
		<cfset newRelation.setMultiplicity(arguments.relationship.srcRelMultiplicity)>
    <cfelseif tableName eq arguments.relationship.targetTable >
        <cfif arguments.relationship.targetRelEnabled eq false>
            <cfreturn>
        </cfif>
        <cfset isSrcRelation = false>
		<cfset newRelation.setRelationName(arguments.relationship.targetRelName)>
		<cfset newRelation.setTargetTable(arguments.relationship.srcTable)>
		<cfset newRelation.setMultiplicity(arguments.relationship.targetRelMultiplicity)>
    <cfelse>
        <cfthrow message="Invalid table relationship for table #tableName#" >
    </cfif>
    
	<cfset newRelation.setLinkTable(arguments.relationship.linkTable)>
    
    <cfloop index = "i" from = "1" to = "#arraylen(arguments.relationship.linkTableConditions)#" step="2"> 
			<cfset var newJoin = createObject("Component","framework.ORMJoinCondition" )>
			<cfset newJoin.setSourceField(arguments.relationship.linkTableConditions[i])>
			<cfset newJoin.setTargetField(arguments.relationship.linkTableConditions[i+1])>
			<cfset newRelation.addJoin(newJoin)>		
    </cfloop>
    
	<cfset arguments.sessionTable.addRelation(newRelation)>		
</cffunction>


