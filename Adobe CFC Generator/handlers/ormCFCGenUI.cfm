<cfsetting showDebugOutput = "no" >


<cfset session.ormMgr= createObject("component","framework.ORMManager")>
<cftry>
	<cfinvoke component="#session.ormMgr#" method="loadTables" returnvariable="Session.ormTables">
	<cfcatch>
		<cflog file="bolt" text="#cfcatch.message# Detail :  #cfcatch.detail#" />
    </cfcatch>
</cftry>


<cfset tables = Session.ormTables>
<cfset tableCount = tables.size()>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" >

<script src="include_scripts.js" type="text/javascript"></script>

</head>

<script type="text/javascript">

	$(document).ready(function ()
	{
		// for some reason calling getParentUrl method does not work in some versions Safari on Mac.
		//So moving that code here
	    <cfset reqUrl = getPageContext().getRequest().GetRequestUrl()>
	    <cfset javaStr = createObject("java","java.lang.String")>
    	<cfset javaStr.init(reqUrl)>
    	<cfset parentUrl = javaStr.subString(0, javaStr.lastIndexOf("/"))>
 		<cfoutput>setPostUrl('#parentUrl#/ormCodeGenHandler.cfm');</cfoutput>
		var tables = createTables();
		start(tables);
	});
</script>


<cffunction name="getParentUrl">
    <cfset var reqUrl = getPageContext().getRequest().GetRequestUrl()>
    <cfset javaStr = createObject("java","java.lang.String")>
    <cfset javaStr.init(reqUrl)>
    <cfset parentUrl = javaStr.subString(0, javaStr.lastIndexOf("/"))>
    <cfreturn parentUrl>
</cffunction>

<cffunction name="createTableJS" >
    <cfargument name="tables" required="true" type="array" >
    <cfoutput>
        <script language="JavaScript">
        	function createTables() {
				var tables = new Array();
				var tmpTable;
		        <cfloop array="#tables#" index="table">
					tmpTable = _createTable('#table.tablename#');
					<cfloop array="#table.fields#" index="field">
						var tableCol = _createColumn(tmpTable, '#field.CFCFIELDNAME#', '#field.TYPE#', 0, #field.PRIMARYKEY#, '#field.CFCFIELDTYPE#');
						if (tableCol != undefined)
						{
							tableCol.isForeignKey = #field.getIsFK()#;
							if (tableCol.isForeignKey == true)
								tableCol.isSelected = false;
						}    
					</cfloop>
					tables.push(tmpTable);
		        </cfloop>
				return tables;
			}
        </script>
    </cfoutput>
</cffunction>

<cfset createTableJS(tables)>

<body>
<!---	<script language="javascript">
		<cfoutput>setPostUrl('#getParentUrl()#/ormCodeGenHandler.cfm');</cfoutput> 
	</script>
--->	
	
	<div id="_header_">
		<table width=95%>
			<tr>
				<td><h2>ORM CFC Generator:</h2></td>
				<td align="right">
					<img id ="helpLink" src="image/Help-Button-Over.png"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="_tables_"></div>
	<div id="_footer_">
		<div id="_status_"></div>
	</div>
	
</body>
</html>