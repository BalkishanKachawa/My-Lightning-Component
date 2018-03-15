({
	getEMI : function(component, detail) {
        if(detail =="EMI"){
            document.getElementById("emiDiv").style.display = "block";
            document.getElementById("addMonthlyDetail").style.display = "none";
        }else if(detail =="Monthly"){
            document.getElementById("emiDiv").style.display = "none";
            document.getElementById("addMonthlyDetail").style.display = "block";
        }
		var loanAmt = document.getElementById('loanAmt').value;
        var months = document.getElementById('months').value;
        var rate = document.getElementById('rate').value;
        
        if (loanAmt == null || loanAmt.length == 0 || months == null || months.length == 0 || rate == null || rate.length == 0) { 
            document.getElementById("err").style.display = "block";            
        } else {
            document.getElementById("err").style.display = "none";                          
            var rate1 = rate / 1200;
            var emi= Math.round(loanAmt * rate1 / (1 - (Math.pow(1 / (1 + rate1), months))) * 100) / 100;
            document.getElementById('EMI').innerHTML = emi;
            document.getElementById('interestP').innerHTML = Math.round((emi * months) * 100) / 100;
            document.getElementById('totalP').innerHTML = Math.round(((document.getElementById('interestP').innerHTML) * 1 - loanAmt * 1) * 100) / 100;
            
            var tile='<ul class="slds-list--vertical slds-has-cards">';
            var balance=0;
            for(i=1; i<=months; i++){                    
                if(i==1){
                    balance = loanAmt;                       
                }                       
                var interest = (Math.round((balance* (rate/100.0)/12)*100)/100).toFixed(2);//(balance* (rate/100.0)/months).toFixed(2);
                var Principal = (Math.round((emi - interest)*100)/100).toFixed(2);
                balance = (Math.round((balance - Principal)*100)/100).toFixed(2);
                
                tile += '<li class="slds-list__item">';
                tile += '<div class="slds-tile slds-tile--board">';
                tile += '<p class="slds-tile__title slds-truncate"><a href="#">Month - '+ i +' </a></p>';
                tile += '<div class="slds-tile__detail">';
                tile += '<p class="slds-text-heading--medium">Installment - '+ emi +'</p>';
                tile += '<p class="slds-truncate"><a href="#">Interest - '+ interest +'</a></p>';
                tile += '<p class="slds-truncate">Princple - '+ Principal +'</p>';
                tile += '<p class="slds-truncate">Balance - '+ balance +'</p>';
                tile += '</div>';
                tile += '</div>';
                tile += '</li>';
            }
            tile += '</ul>';
            document.getElementById("addMonthlyDetail").innerHTML = tile;            
        }	
	}
})