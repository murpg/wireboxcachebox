<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->
<cfcomponent output="false">
	<cffunction name="getLocation" output="false">
		<cfreturn session.location>
	</cffunction>
	
	<cffunction name="setLocation" output="false">
		<cfargument name="location">
		<cfset session.location = arguments.location>
	</cffunction>
	
	<cffunction name="getscriptbased" output="false">
		<cfset userDefinedFields= requestinfo.getUserDefinedFileds()>
		<cfloop array="#userDefinedFields#" index="property">
			<cfif property.getName() eq "scriptbased">
				<cfset setscriptbased(property.getValue())>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfreturn session.scriptbased>
	</cffunction>
	
	<cffunction name="isGenerateServices" output="false">
		<cfset userDefinedFields= requestinfo.getUserDefinedFileds()>
		<cfloop array="#userDefinedFields#" index="property">
			<cfif property.getName() eq "generateService">
				<cfset setGenerateServices(property.getValue())>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfreturn session.generateServices>
	</cffunction>

	<cffunction name="setGenerateServices" output="false">
		<cfargument name="generateServices">
        <cfset session.generateServices = arguments.generateServices>
	</cffunction>

	
	<cffunction name="setscriptbased" output="false">
		<cfargument name="scriptbased">
		<cfset session.scriptbased = arguments.scriptbased>
	</cffunction>
	
	<cffunction name="getDatabase" output="false">
		<cfreturn session.database>
	</cffunction>
	
	<cffunction name="setDatabase" output="false">
		<cfargument name="database">
		<cfset session.database = arguments.database>
	</cffunction>
		
	<cffunction name="setCFCName" access="remote" >
		<cfargument name="tablename">
		<cfargument name="CFCName">
				<cfloop array="#session.ormTables#" index="tableInfo">
				<cfif tableInfo.getTableName() eq tablename>
					<cfset tableInfo.setCFCName(CFCName)>
				</cfif>
			</cfloop>		
	</cffunction>
	<cffunction name="getCFCName" access="remote">
		<cfargument name="tablename">
			<cfloop array="#session.ormTables#" index="tableInfo">
				<cfif tableInfo.getTableName() eq tablename>
					<cfreturn tableInfo.getCFCName()>
				</cfif>
			</cfloop>

	</cffunction>
	
	<cffunction name="getTables">
		<cfreturn session.ormTables>
	</cffunction>
	
	<cffunction name="getFields" access=remote>
		<cfargument name=tablename required=true>
		<cfloop array="#session.ormTables#" index="tableInfo">
			<cfif tableInfo.getTableName() eq tablename>
				<cfreturn tableInfo.getFields()>
			</cfif>
		</cfloop>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="loadTables" returntype="ORMTable[]">
		<cfset var ormTables=[]>
		<cfinvoke component="RequestProcessor" method="parseRequest" returnVariable="requestinfo" eventInfoXML="#application[url.genId]#">
		<cfset application[url.genId] = "">
		<cfset fetchLocation(requestinfo.getUserDefinedFileds())>
		<cfset setDatabase(requestinfo.getRDSInfo().getDatabaseName())>
		<cfset tables = requestinfo.getRDSInfo().getTables()>
		<cfloop from="1" to="#tables.size()#" index="i">
			<cfset ormTable = loadTable(tables[i])>
			<cfset ArrayAppend(local.ormTables,ormTable)>
		</cfloop>
		<cfreturn local.ormTables>
	</cffunction>
	
	<cffunction name="fetchLocation">
		<cfargument name="userDefinedFields" type="Property[]">
		<cfloop array="#userDefinedFields#" index="property">
			<cfif property.getName() eq "Location">
				<cfset setlocation(property.getValue())>
				<cfbreak>
			</cfif>
		</cfloop>
    </cffunction>
	
	<cffunction name=loadTable returntype="ORMTable">
		<cfargument name="tableinfo" required="true">
		<cfset var ormTable = createObject("Component","ORMTable")>
		<cfset ormTable.setTableName(removeSchemaInTableName(tableInfo, ormTable))>
		<cfset ormTable.setCFCName(ormTable.getTableName())>
		<cfset var fields = tableinfo.getFields()>
		
		<cftry>
			<cfdbinfo datasource="#getDatabase()#" table="#ormTable.getTableName()#" type="columns" name="result">
			<cfcatch type="any">
			</cfcatch>
		</cftry>
		
		<cfset var foreignKeys = {}>
		<cfif isdefined("result")>
			<cfloop query="result">
				<cfif result.IS_FOREIGNKEY>
					<cfset structInsert(foreignKeys,result.COLUMN_NAME, result.COLUMN_NAME, true)>
				</cfif>
			</cfloop>	
			<cfset ormTable.setImportedForeignKeys(foreignKeys)>
		</cfif>

		<cfloop from=1 to="#fields.size()#" index=i>
			<cfset var ormField = loadField(fields[i])>
			<cfset ormTable.addField(ormField)>

			<cfif structkeyexists(foreignKeys,fields[i].getName())>
				<cfset ormField.setIsFK(true)>
			</cfif>

<!---			<cfif !structkeyexists(foreignKeys,fields[i].getName())>
				<cfset var ormField = loadField(fields[i])>
				<cfset ormTable.addField(ormField)>
			</cfif>
--->		
		</cfloop>
		
		<cfreturn ormTable>
	</cffunction>
	
	<cffunction name="loadField" returntype="ORMField">
		<cfargument name="fieldInfo" required="true">
		<cfset var ormField = createObject("Component","ORMField")>
		<cfset ormField.setCFCFieldName(fieldInfo.getName())>
		<cfset ormField.setCFCFieldType(getPreferredORMType(fieldInfo.getJavaType()))>
		<cfset ormField.setName(fieldInfo.getName())>
		<cfset ormField.setType(fieldInfo.getType())>
		<cfset ormField.setCFType(fieldInfo.getCFType())>
		<cfset ormField.setPrimaryKey(fieldInfo.isPrimaryKey())>
		<cfset ormfield.setSelected(true)>
		<cfreturn ormField>
	</cffunction>
	
	<cffunction name="removeSchemaInTableName" returntype="string">
		<cfargument name="tableInfo" type="TableInfo">
		<cfargument name="ormTable" type="ORMTable">
		
		<cfset var tableName = tableInfo.getTableName()>
		<cfif tableName contains ".">
			<cfset var tableNameWithoutDot = listlast(tableName, ".")>
			<cfset ormTable.setSchema(listfirst(tableName, "."))>
			<cfset tableName = tableNameWithoutDot>
		<cfelse>
			<cfset ormTable.setSchema("")>
		</cfif>
		<cfreturn tableName>
	</cffunction>
	
	<cffunction name="getTableInfo" access="public" returntype="ORMTable">
		<cfargument name="tablename" required=true>
		<cfloop array="#session.ormTables#" index="local.tableInfo">
			<cfif local.tableInfo.getTableName() eq tablename>
				<cfreturn local.tableInfo>
			</cfif>
		</cfloop>
    </cffunction>
	
	<cffunction name="getRelationInfo" access="private" returntype="ORMRelation">
		<cfargument name="tableInfo" type="ORMTable" required=true>
		<cfargument name="relation" required="true">
		<cfset relations = tableInfo.getRelations()>
		<cfif (ArrayLen(relations) GT 0)>
	        <cfloop array="#relations#" index="local.relationobj">
	        	<cfif local.relationobj.getRelationName() eq relation>
	        		<cfreturn local.relationobj>
				</cfif>
	        </cfloop>
		</cfif>
    </cffunction>	
	
	<cffunction name="getLHJoinFieldsAsList">
		<cfargument name="tableName" required=true>
		<cfargument name="relationname" required=true>
	
		<cfset var tableInfo = getTableInfo(tableName)>
		<cfset var relationInfo = getRelationInfo(tableInfo, arguments.relationname)>
		<cfset var sourceTableFields = tableInfo.getFieldNames()>
		<cfset var linkTable = relationInfo.getLinkTable()>
		<cfif isDefined("linkTable") && linkTable NEQ "">
			<cfset var linkTableFields = getTableInfo(linkTable).getFieldNames()>
		</cfif>
		<cfif isDefined("linkTableFields")>
			<cfset sourceTableFields.addAll(linkTableFields)>
		</cfif>
		<cfreturn arrayToList(sourceTableFields)>
    </cffunction>
	
	<cffunction name="getRHJoinFieldsAsList">
		<cfargument name="tableName" required=true>
		<cfargument name="relationname" required=true>
	
		<cfset var tableInfo = getTableInfo(tableName)>
		<cfset var relationInfo = getRelationInfo(tableInfo, arguments.relationname)>
		<cfset var targetTable = relationInfo.gettargetTable()>
		<cfif isDefined("targetTable") && targetTable NEQ "">
			<cfset var targetTableFields = getTableInfo(targetTable).getFieldNames()>
		</cfif>		
		<cfset var linkTable = relationInfo.getLinkTable()>
		<cfif isDefined("linkTable") && linkTable NEQ "">
			<cfset var linkTableFields = getTableInfo(linkTable).getFieldNames()>
			<cfif isDefined("targetTableFields")>
				<cfset targetTableFields.addAll(linkTableFields)>
			</cfif>
		</cfif>
		<cfif isDefined("targetTableFields")>
			<cfreturn arrayToList(targetTableFields,",")>
		</cfif>
		<cfreturn "">
	</cffunction>    
		
	<cffunction name="getFKColumn">
		<cfargument name="currentTableInfo" type="ORMTable">
		<cfargument name="relation" type="ORMRelation">
		<cfset var multiplicity = relation.getmultiplicity()>
		<cfset var joins = relation.getJoins()>
		<cfset var targetTable = relation.gettargetTable()>
		<cfset var sourceTable = currentTableInfo.getTableName()>
		
		<cfswitch expression="#multiplicity#">
			<cfcase value="1-1">
			<!--- As we are not guaranteed to have foreign key information for the table we are not supporting the case
				  where PK and FK are same for one-to-one mapping. What we assume is the column which is not primary key
				  is foreign key.
			 --->
			 	<cfset var targetTableInfo = getTableInfo(targetTable)>
			 	<cfset var targetTableRelations = targetTableInfo.getRelations()>
			 	<cfset var targetRelationFound = false>
			 	<cfset var targetRelationName = "">
			 	<cfloop array="#targetTableRelations#" index="local.targetRelation">
			 		<cfif local.targetRelation.gettargetTable() eq sourceTable>
			 			<cfset targetRelationFound = true>
			 			<cfset targetRelationName = local.targetRelation.getrelationName()>
			 			<cfif Arraylen(local.targetRelation.getJoins()) eq 0>
			 				<cfset local.targetRelation.setJoins(relation.getJoins())>
						</cfif>
			 			<cfbreak>
			 		</cfif>
			 	</cfloop>
				<!--- insert 1-1 relation in the target table also as we are forcefully making 1-1 relational bidirectional --->
				<cfif !targetRelationFound>
					<cfset var newRelation = new ORMRelation()>
					<cfset newRelation.setrelationName(sourceTable)>
					<cfset newRelation.setmultiplicity("1-1")>
					<cfset newRelation.settargetTable(sourceTable)>
					<cfset newRelation.setJoins(relation.getJoins())>
					<cfset targetTableInfo.addRelation(newRelation)>
					<cfset local.targetRelation = newRelation>
					<cfset targetRelationName = newRelation.getrelationName()>
				</cfif>
				<cfset var fkcolumn="">
				<!--- For 1-1 Join should have only one record as we are not handling composite key as of now --->
				<cfloop array="#joins#" index="local.join">
					<cfset var sourcefield = local.join.getsourceField()>
					<cfset var targetfield = local.join.gettargetField()>
					<cfif currentTableInfo.isPrimaryKey(listLast(sourcefield,"."))>
						<cfset relation.setFKcolSideFor1to1Relation(3)>
						<cfset relation.setMappedby(targetRelationName)>
						<cfset local.targetRelation.setFKcolSideFor1to1Relation(2)>
						<cfset fkcolumn=listLast(targetfield,".")>
					<cfelse>
						<cfset relation.setFKcolSideFor1to1Relation(2)>
						<cfset local.targetRelation.setFKcolSideFor1to1Relation(3)>
						<cfset local.targetRelation.setMappedby(relation.getrelationName())>
						<cfset fkcolumn=listLast(sourcefield,".")>
					</cfif>
					<cfreturn fkcolumn>
				</cfloop>
	        </cfcase>
			<!--- Add the join column in foreign keys list by assuming that join column 
			in the table at many side of the relation is foreign key, so that <cfproperty>
			should not be generated for this foreign key column. This tries to solve problem
			where foreign key constraint is not specified in the table --->
			<cfcase value="1-n">
				<cfset var joinCol = getJoinColumnForTable(joins, targetTable)>
				<cfset targetTableInfo = session.ormMgr.getTableInfo(targetTable)>
				<cfset targetTableInfo.addImportedForeignKey(joinCol)>
				<cfreturn joinCol>
            </cfcase>
			<cfcase value="n-1">
				<cfset var joinCol = getJoinColumnForTable(joins, sourceTable)>
				<cfset currentTableInfo.addImportedForeignKey(joinCol)>
				<cfreturn joinCol>
			</cfcase>
			<cfcase value="m-n">
				<!--- wrong case. It will never come here --->
			</cfcase>			
			<cfdefaultcase>
				<cfreturn "">
            </cfdefaultcase>
	    </cfswitch>		
    </cffunction>
	
	<cffunction name="getFKColumnForLinkedTable">
		<cfargument name="currentTableInfo" type="ORMTable">
		<cfargument name="relation" type="ORMRelation">
		<cfset var multiplicity = relation.getmultiplicity()>
		<cfset var joins = relation.getJoins()>
		<cfset var targetTable = relation.gettargetTable()>
		<cfset var linkedTable = relation.getLinkTable()>
		<cfset var sourceTable = currentTableInfo.getTableName()>

		<cfswitch expression="#multiplicity#">
			<cfcase value="1-1">
				<!--- wrong case. It will never come here --->
	        </cfcase>
			<cfcase value="1-n">
				<cfreturn getJoinColumnForLinkedTable(sourceTable,targetTable,linkedTable,joins)>
            </cfcase>
			<cfcase value="n-1">
				<cfreturn getJoinColumnForLinkedTable(sourceTable,targetTable,linkedTable,joins)>
			</cfcase>
			<cfcase value="m-n">
				<cfreturn getJoinColumnForLinkedTable(sourceTable,targetTable,linkedTable,joins)>
			</cfcase>			
			<cfdefaultcase>
				<cfreturn "">
            </cfdefaultcase>
	    </cfswitch>		
    </cffunction>
		
	<cffunction name="getJoinColumnForLinkedTable" access="private">
		<cfargument name="sourceTable" required="true">
		<cfargument name="targetTable" required="true">
		<cfargument name="linkedTable" required="true">
		<cfargument name="joins" required="true">
		<cfset var linkedfkCols = "">
		<cfloop array="#joins#" index="local.join">
			<cfset var sourcefield = local.join.getsourceField()>
			<cfset var targetfield = local.join.gettargetField()>
			<cfif listFirst(sourcefield,".") eq sourceTable && listFirst(targetfield,".") eq linkedTable>
				<cfset linkedfkCols = listAppend(linkedfkCols,listLast(targetfield,"."),",")>
			</cfif>		
			<cfif listFirst(sourcefield,".") eq linkedTable && listFirst(targetfield,".") eq sourceTable>
				<cfset linkedfkCols = listPrepend(linkedfkCols,listLast(sourcefield,"."),",")>
			</cfif>			
			<cfif listFirst(sourcefield,".") eq targetTable && listFirst(targetfield,".") eq linkedTable>
				<cfset linkedfkCols = listAppend(linkedfkCols,listLast(targetfield,"."),",")>
			</cfif>		
			<cfif listFirst(sourcefield,".") eq linkedTable && listFirst(targetfield,".") eq targetTable>
				<cfset linkedfkCols = listAppend(linkedfkCols,listLast(sourcefield,"."),",")>
			</cfif>												
		</cfloop>	
		<cfreturn linkedfkCols>	
    </cffunction>	
	
	<cffunction name="getJoinColumnForTable" access="private">
		<cfargument name="joins">
		<cfargument name="targetTable">
		<cfloop array="#joins#" index="local.join">
			<cfset var sourcefield = local.join.getsourceField()>
			<cfif listFirst(sourcefield,".") eq targetTable>
				<cfreturn listLast(sourcefield,".")>
			</cfif>
			<cfset var targetfield = local.join.gettargetField()>
			<cfif listFirst(targetfield,".") eq targetTable>
				<cfreturn listLast(targetfield,".")>
			</cfif>						 
		</cfloop>			
    </cffunction>	
		
	<cfscript>
	    public String function getPreferredORMType(sqlType)
	    {
		   var Types = createobject("java","java.sql.Types");
		   var sqlTypeVsJavaType = {};
	       sqlTypeVsJavaType.put(Types.TINYINT, "byte");
	       sqlTypeVsJavaType.put(Types.SMALLINT, "short");
	       sqlTypeVsJavaType.put(Types.INTEGER, "int");
	       sqlTypeVsJavaType.put(Types.BIGINT, "long");
	       sqlTypeVsJavaType.put(Types.REAL, "float");
	       sqlTypeVsJavaType.put(Types.FLOAT, "double");
	       sqlTypeVsJavaType.put(Types.DOUBLE, "double");
	       sqlTypeVsJavaType.put(Types.DECIMAL, "double");
	       sqlTypeVsJavaType.put(Types.NUMERIC, "double");
	       sqlTypeVsJavaType.put(Types.BIT, "boolean");
	       sqlTypeVsJavaType.put(Types.CHAR, "string");
	       sqlTypeVsJavaType.put(Types.VARCHAR, "string");
	       sqlTypeVsJavaType.put(Types.LONGVARCHAR, "string");
	       sqlTypeVsJavaType.put(Types.BINARY, "byte[]");
	       sqlTypeVsJavaType.put(Types.VARBINARY, "byte[]");
	       sqlTypeVsJavaType.put(Types.DATE, "date");
	       sqlTypeVsJavaType.put(Types.TIME, "java.sql.Time");
	       sqlTypeVsJavaType.put(Types.TIMESTAMP, "timestamp");
	       sqlTypeVsJavaType.put(Types.CLOB, "clob");
	       sqlTypeVsJavaType.put(Types.BLOB, "blob");
	       sqlTypeVsJavaType.put(Types.ARRAY, "java.sql.Array");
	       sqlTypeVsJavaType.put(Types.JAVA_OBJECT, "java.lang.Object");
	       var result = sqlTypeVsJavaType.get(sqlType);
	       if (isnull(result))
	       {
	           result = "java.lang.Object";
	       }
	       return result;
	    }    

		public String function getAllORMTypes()
		{
			var types = "byte,short,int,long,float,double,boolean,string,byte[],date,java.sql.Time,timestamp,clob,blob,java.sql.Array,java.lang.Object,java.math.BigDecimal";
			return types;
		}
    </cfscript>
</cfcomponent>