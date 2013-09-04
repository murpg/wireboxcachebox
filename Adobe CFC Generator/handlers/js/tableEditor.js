/*
ADOBE SYSTEMS INCORPORATED
 Copyright 2011 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
*/

//Author : Ram Kulkarni

_tableEditorDlg = null;
_tblEditorDlgClass = "tableEditorDlg"

_rowDataObjName = "rowData";
_cellDataObjName = "cellData";

_editorPropName = "editorPropName";
_editorPropType = "editorPropType";
_editorPrimaryKey = "editorPrimaryKey";
_colSelectClass = "colSelect";

_propertyNameCellEditor = "propertyNameCellEditor";
_propertyNameCellEditorId = "tableCellTextEditorId";

_propertyTypeCellEditor = "_propertyTypeCellEditor";
_propertyTypeCellEditorId = "propertyTypeCellEditorId";
_tableEditorToolTipId = "tableEditorToolTipId";

_propNameEditCtrlJQ = null;
_propTypeEditorCtrlJQ = null;

_propTypeArray = new Array (
	"byte",
	"short",
	"int",
	"long",
	"float",
	"double",
	"boolean",
	"string",
	"byte[]",
	"date",
	"java.sql.Time",
	"timestamp",
	"clob",
	"blob",
	"java.sql.Array",
	"java.lang.Object",
	"java.math.BigDecimal"
);

var tableEditorJS = {
	dbTable : null,
	orgDbTable : null,
	
	onTableEditorLoadPageContent :  function (data)
	{
		$(_tableEditorDlg).html(data);
		$("input#allColsChkbox").change(tableEditorJS.onSelectAllColumn);
		tableEditorJS.loadData();
		setupTableEditorToolTip();
	},
	
	onSaveTable : function ()
	{
		$.extend(true, tableEditorJS.orgDbTable, tableEditorJS.dbTable);
		tableEditorJS.orgDbTable.cfcName = $("div#cfcNameDiv' input[name|='cfcname']").val();
		tableEditorJS.closeTableEditorDlg();
	},
	
	onCancelTableEditor :  function (){
		tableEditorJS.closeTableEditorDlg();
	},
	
	closeTableEditorDlg :  function () {
		tableEditorJS.orgDbTable = null;
		tableEditorJS.dbTable = null;
		$(_tableEditorDlg).dialog("close");	
	},
	
	loadData : function()
	{
		var table = $("table#editorTable");
		$("tr." + _colSelectClass).remove();
		
		$("div#cfcNameDiv' input[name|='cfcname']").val(tableEditorJS.dbTable.cfcName);
		
		$.each(tableEditorJS.dbTable.cols, function (index, col)
		{
			var rowStr = "<tr class='" + _colSelectClass + "'>" + 
				"<td class='editorSelect'>";
				
			if (col.isForeignKey == false)
			{
				rowStr += "<input type='checkbox' name='isSelected'";
				if (col.isSelected == true)
					rowStr += " checked='checked'";
				rowStr += "/>";
			} else
			{
				col.isSelected = false;
				rowStr += "<span class='FKIndicator'>F</span>";
			}
			 
			rowStr += "</td>" +
				"<td class='editorColName'>" + col.name + "</td>" +
				"<td class='editorColType'>" + col.type + "</td>" +
				"<td class='" + _editorPropName + "'>" + col.propertyName + "</td>" +
				"<td class='" + _editorPropType + "'>" + col.propertyType + "</td>" +
				"<td class='" + _editorPrimaryKey + "'>";
				
			if (col.isForeignKey == false) {
				rowStr += "<input type='checkbox' name='isPrimary'";
				
				if (col.isPrimaryKey == true) 
					rowStr += " checked='checked'";
				rowStr += "/>";
			}
				
			rowStr += "</td>" +
				"</tr>";
			var rowJQ = $(rowStr).appendTo(table);
			$(rowJQ).data(_rowDataObjName, col);
		});
		
		$("td." + _editorPropName).click(tableEditorJS.onEditableCellClick);
		$("td." + _editorPropType).click(tableEditorJS.onEditableCellClick);
		$("td").children("[name|=isSelected]").change(tableEditorJS.onSelectedColChanged);
		$("td").children("[name|=isPrimary]").change(tableEditorJS.onPrimaryColChanged);
		tableEditorJS.updateSelAllColChkStatus();
		
//		$(".FKIndicator").hover(function(event){
//			showTableEditorToolTip(event,"Foreign Key");
//		}, function(event) {
//			hideTableEditorToolTip();
//		});
	},
	
	onEditableCellClick : function (event)
	{
		if ($(this).hasClass(_editorPropName))
		{
			//editing property name
			tableEditorJS.editPropertyName($(this));
		} else if ($(this).hasClass(_editorPropType))
		{
			//editing property type
			tableEditorJS.editPropertyType($(this));
		}
	},
	
	editPropertyName : function(htmlCol)
	{
		var rowJQ = $(htmlCol).parent();
		var colData = $(rowJQ).data(_rowDataObjName);
		
		if (_propNameEditCtrlJQ == undefined)
		{
			var tmpStr = "<div class='" + _propertyNameCellEditor + "'>" + 
				"<input type='text' name='celltxteditor' id='" + _propertyNameCellEditorId + "'></input>" +
				"</div>";
				
			_propNameEditCtrlJQ = $(tmpStr).appendTo("#tableEditorDiv");
			
			var textCtrl = $("#"+_propertyNameCellEditorId);
			textCtrl.blur(tableEditorJS.onPropertyEditBlur);	
		}
		
		var textCtrl = $("#"+_propertyNameCellEditorId);
		textCtrl.val(colData.propertyName);

		$(_propNameEditCtrlJQ).show();
		
		$(_propNameEditCtrlJQ).css({"zindex" : 0});
		$(_propNameEditCtrlJQ).offset({left : $(htmlCol).offset().left, top : $(htmlCol).offset().top});
		$(textCtrl).width($(htmlCol).width());
		$(textCtrl).height( $(htmlCol).height());
		$(_propNameEditCtrlJQ).width($(htmlCol).width());
		$(_propNameEditCtrlJQ).height( $(htmlCol).height());
		$(_propNameEditCtrlJQ).data(_cellDataObjName, $(htmlCol));

		textCtrl.focus();
	},
	
	onPropertyEditBlur : function (event)
	{
		var htmlCol  = $(_propNameEditCtrlJQ).data(_cellDataObjName);
		var rowJQ = $(htmlCol).parent();
		var colData = $(rowJQ).data(_rowDataObjName);
		
		$(_propNameEditCtrlJQ).data(_cellDataObjName, null);
		
		var textCtrl = $("#"+_propertyNameCellEditorId);
		
		$(htmlCol).html(textCtrl.val());
		if (colData != undefined)
			colData.propertyName = textCtrl.val();
		
		$(_propNameEditCtrlJQ).hide();
	},
	
	editPropertyType : function(htmlCol)
	{
		var rowJQ = $(htmlCol).parent();
		var colData = $(rowJQ).data(_rowDataObjName);
		
		if (_propTypeEditorCtrlJQ == undefined)
		{
			var tmpStr = "<div class='" + _propertyTypeCellEditor + "'>" + 
				"<select name='typeEditor' id='" + _propertyTypeCellEditorId + "'>";
			$.each(_propTypeArray, function(index, item)
			{
				tmpStr += "<option value='" + item + "' "
				if (colData.propertyType == item)
					tmpStr += "selected='selected'"; 
				tmpStr += ">" + item + "</option>";
			});
			tmpStr += "</select></div>";
				
			_propTypeEditorCtrlJQ = $(tmpStr).appendTo("#tableEditorDiv");
			
			var selCtrl = $("#"+_propertyTypeCellEditorId);
			selCtrl.blur(tableEditorJS.onPropertyTypeEditBlur);	
		}
		
		var selCtrl = $("#"+_propertyTypeCellEditorId);
		var optionCtrl = $("select > option").filter("[selected |='selected']");
		if (optionCtrl.length > 0)
			optionCtrl.removeAttr("selected");	
		
		optionCtrl = $("select > option").filter("[value |='" + colData.propertyType + "']");
		if (optionCtrl.length > 0)
			optionCtrl.attr("selected", "selected");
		

		$(_propTypeEditorCtrlJQ).show();
		
		$(_propTypeEditorCtrlJQ).css({"zindex" : 0});
		$(_propTypeEditorCtrlJQ).offset({left : $(htmlCol).offset().left, top : $(htmlCol).offset().top});
		$(selCtrl).width($(htmlCol).width());
		$(selCtrl).height( $(htmlCol).height());
		$(_propTypeEditorCtrlJQ).width($(htmlCol).width());
		$(_propTypeEditorCtrlJQ).height( $(htmlCol).height());
		$(_propTypeEditorCtrlJQ).data(_cellDataObjName, $(htmlCol));

		selCtrl.focus();
	},
	
	onPropertyTypeEditBlur : function (event)
	{
		var htmlCol  = $(_propTypeEditorCtrlJQ).data(_cellDataObjName);
		var rowJQ = $(htmlCol).parent();
		var colData = $(rowJQ).data(_rowDataObjName);
		
		$(_propTypeEditorCtrlJQ).data(_cellDataObjName, null);
		
		var selCtrl = $("#"+_propertyTypeCellEditorId);
		
		$(htmlCol).html(selCtrl.val());
		colData.propertyType = selCtrl.val();
		
		$(_propTypeEditorCtrlJQ).hide();
	},
	
	onSelectedColChanged : function (event)
	{
		var rowJQ = $(this).parents("tr");
		var colData = $(rowJQ).data(_rowDataObjName);
		
		colData.isSelected = !colData.isSelected;
		tableEditorJS.updateSelAllColChkStatus();
	},
	
	onPrimaryColChanged : function (event)
	{
		var rowJQ = $(this).parents("tr");
		var colData = $(rowJQ).data(_rowDataObjName);
		
		colData.isPrimaryKey = !colData.isPrimaryKey;
	},
	
	onSelectAllColumn : function ()
	{
		var allColSelChkBoxes = $("table#editorTable input[name|='isSelected']");
		var isSelected;
		
		if ($("input#allColsChkbox").attr('checked') == undefined) {
			isSelected = false;
			allColSelChkBoxes.removeAttr('checked');
		}
		else {
			isSelected = true;
			allColSelChkBoxes.attr('checked', 'checked');
		}
	
		$.each(allColSelChkBoxes, function(chkCtrl){
			var rowJQ = $(this).parents("tr");
			var colData = $(rowJQ).data(_rowDataObjName);
			colData.isSelected = isSelected;
		});
	},
	
	updateSelAllColChkStatus : function()
	{
		var allColSelChkBoxes = $("table#editorTable input[name|='isSelected']");
		var allSelected = true;
		$.each(allColSelChkBoxes, function(chkCtrl){
			var rowJQ = $(this).parents("tr");
			var colData = $(rowJQ).data(_rowDataObjName);
			if (colData.isSelected == false)
				allSelected = false;
		});
		
		if (allSelected) {
			if ($("input#allColsChkbox").attr('checked') == undefined)
				$("input#allColsChkbox").attr('checked', 'checked');
		}
		else 
			$("input#allColsChkbox").removeAttr('checked');
	},
}

function createTableEditor (dbTable, offset)
{
	//make a copy of dbTable
	tableEditorJS.orgDbTable = dbTable;
	tableEditorJS.dbTable = cloneObject(dbTable, ["relations"]);
	
	if (_tableEditorDlg == undefined)
	{
		var pageContent = $.get("tableEditor.html", tableEditorJS.onTableEditorLoadPageContent);
		
		var dlgDiv = "<div class='" + _tblEditorDlgClass + "'>" +
		"</div>";
		$("body").append(dlgDiv);
		_tableEditorDlg  = $("." + _tblEditorDlgClass).dialog({
			dialogClass : "tableEditorDlg",
			autoOpen : false,
			height : 350,
			width : 600,
			modal : true,
			buttons : {
				"Save" : tableEditorJS.onSaveTable,
				"Cancel" : tableEditorJS.onCancelTableEditor,
			},
			title : dbTable.name,
		});
	} 
	else
	{
		_tableEditorDlg.dialog("option", {'title' : tableEditorJS.dbTable.name});
		tableEditorJS.loadData();
	}

	_tableEditorDlg.dialog("option", "position", [offset.left, offset.top]);
	_tableEditorDlg.dialog("open");
}

function setupTableEditorToolTip()
{
	var tip = "<div id='" + _tableEditorToolTipId + "'> </div>";
	$("#tableEditorDiv").append(tip);
	
}

function showTableEditorToolTip(event, tip)
{
	var x = event.clientX + 10;
	var y = event.clientY - 10;
	
	$("#" + _tableEditorToolTipId).
		css({zindex : 0, position : "absolute", left : x, top : y}).
		html(tip).
		show();
}

function hideTableEditorToolTip ()
{
	$("#" + _tableEditorToolTipId).hide();
}
