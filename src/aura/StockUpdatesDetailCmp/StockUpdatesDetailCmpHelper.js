({
	getStockDetailResult : function(component, symbol) {
        //Calling getStockData of Controller
        var action = component.get("c.getStockData");
        action.setParams({
            "symbol": symbol //Passing Company symbol
        });
        
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set("v.stockDetail", actionResult.getReturnValue()); 
            console.log(actionResult.getReturnValue());
        });
        $A.enqueueAction(action);        
    },
    getChartData : function(component, symbol) {
        //Calling getStockData of Controller
        var action = component.get("c.getChartData");
        var stocks;
        action.setParams({
            "symbol": symbol //Passing Company symbol
        });
        
        var self = this;
        action.setCallback(this, function(actionResult) {
            var stocks = jQuery.parseJSON(actionResult.getReturnValue()); //getting and parsing json data
            if(stocks != null){
                var quotes = stocks.query.results.quote; //getting stock quotes
                if(quotes != null){
                    //creating table for stock chart
                    var content = "<table class=\"highchart\" style=\"display:none\" data-graph-container-before=\"1\" data-graph-type=\"line\"><thead><tr><th>Date</th><th>Close</th></tr></thead><tbody>";
                    jQuery.each(quotes, function(j, v) { 
                        content += "<tr><td>"+v.Date+"</td><td>"+v.Close +"</td></tr>";
                    });
                    content += "</tbody></table>";
                    
                    jQuery('.tb').append(content);//appending table in div
                    
                    //Creating stock chart using Highchart Table Chart
                    //We can not use Highchart for commercial purpose
                    //I used this to show the demo and how we can use these charts.
                    jQuery('table.highchart').highchartTable();
                }else{
                    var content ="<div style=\" color:red;\">Data not available</div>";
                    jQuery('.tb').append(content);
                }
            }else{
                var content ="<div style=\" color:red;\">Data not available</div>";
                jQuery('.tb').append(content);
            }
        });
        $A.enqueueAction(action);
        
    },
})