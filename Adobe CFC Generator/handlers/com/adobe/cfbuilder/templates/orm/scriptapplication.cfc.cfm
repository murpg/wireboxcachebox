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

<cfoutput>component
{
this.name = "myORMApplication";
this.ormenabled = "true";
this.datasource = "#session.database#";
/* ORM Setting not suggested for production use*/
this.ormsettings = {autorebuild="true"};
}</cfoutput>
<cfsetting enablecfoutputonly="false" />