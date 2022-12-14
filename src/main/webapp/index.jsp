<%@ page import="javax.servlet.http.HttpServlet" %>

<!DOCTYPE html>

<html>

<head>
    <meta charset="utf-8" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="msapplication-tap-highlight" content="no" />
    <meta name="viewport" content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width" />
    <meta http-equiv="Content-Security-Policy" content="default-src * 'unsafe-inline'; style-src 'self' 'unsafe-inline'; media-src *" />
    <link href="https://fonts.googleapis.com/css2?family=Beau+Rivage&family=Lobster&family=Satisfy&display=swap" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <!--
        font-family: 'Beau Rivage', cursive;
        font-family: 'Lobster', cursive;
        font-family: 'Satisfy', cursive;
    -->
    <!--css section-->

    <style>
    *{
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    } 
    table{
        margin: 0.8rem;
    }   
    body{
        display: flex;
        flex-direction: column;
        align-items: center;
        background-image: url("notebookimg.jpg");
        background-repeat: no-repeat;
        background-size: cover;
        font-family:'Lobster', cursive; ;
        
    }
    button{
        font-family: 'Satisfy', cursive;;
    }
    .content-loader tr td {
            white-space: nowrap;
    }
    h1{
        margin-top: 2rem;
        font-size: 3rem;
    }
    h2{
        
        padding: 0.6rem;
        text-align: center;
    }
    

    
    td{
        border-bottom: 0.2px solid grey;
        padding: 0.8rem;
        background-color: orange;
        text-align: center;
    }
    #new_note{
        text-align: center;
    }
    #note_btn,#list_btn{
        display: block;
        margin-top: 5rem;
        width: 10rem;
        font-size: 2rem;
        padding: 1rem;
        border-radius: 5px;
        border: 0.1px solid rgb(199, 192, 192);
        background-color: rgb(225, 233, 228);
    }

    button:hover{
        cursor: pointer;
    }
    #save_button{
        margin: 10px;
        border: none;
        padding: 1rem;
        border-radius: 5px;
        background-color: rgb(13, 223, 13);
        font-size: large;
        letter-spacing: 1px;
    }
    
    #update_btn{
        margin: 10px;
        border: none;
        padding: 1rem;
        border-radius: 5px;
        background-color: rgb(13, 223, 13);
        font-size: large;
        letter-spacing: 1px;
    }
    .update_btn,.delete_btn{
        margin:2px;
        border: none;
        padding: 0.5rem;
        border-radius: 5px;
        background-color: rgb(13, 223, 13);
        font-size: 1rem;
}
    #back,#backSv,.back2{
        margin: 2px;
        margin-left: 1rem;
        border: none;
        padding: 1rem;
        border-radius: 5px;
        background-color: rgb(235, 133, 129);
        font-size: large;
        letter-spacing: 1px;
    }
    
    

    label{
        display: block;
        margin: 0.3rem;
        text-align: center;
        font-size: 1.5rem;
        letter-spacing: 2px;
        font-family: 'Lobster', cursive;
    }
    input,textarea{
        
        border: 0.1px solid rgb(233, 175, 175);
        border-radius: 5px;
        height: 29px;
        outline: none;
        font-size: large;
    }
    textarea{
        height: auto;
        resize: none;
    }
    input:focus{
        background-color: rgb(149, 236, 236);
    }
    textarea:focus{
        background-color: rgb(238, 199, 199);
    }

    </style>
</head>
<!--body section -->

<body >
    <h1>My Notebook</h1>
    <button id="note_btn">New Note</button>
    <button id="list_btn">My Notes</button>
    <div id="new_note" style="display:none;">
        <h2>Insert your note here:</h2>
        <label for="title">Title</label> 
        <input type="text" name="title" cols="30"></input>
        <br>
        <label for="body">My Note</label>
        <textarea name="body" rows="5" cols="30"></textarea>
        <br>
        <button id="save_button" onclick="save()">Save</button>
        <button id="update_btn" onclick="update1()">Update</button>
        <button id = "backSv">Back</button>
        
    </div>
    <div id="list_of_notes" style="display: none;">
        <h2> My notes</h2>
        <div id="mytable">
        
        </div>
        <button id = "back">Back</button>
    </div>
    
    <br>

    <!--javascript section-->


    <script type="text/javascript">
        
        
        
        
        var global_key = 0;
        
        if (localStorage.length === 0) {
        	   localStorage.setItem("global_key",global_key)
        	}
        var db;
        
        var update = ' ';
        var global_date = '';
        const note_btn = $("#note_btn");
        const list_btn = $("#list_btn");
        const back_btn = $("#back");
        const backSv_btn = $("#backSv");
        const back2 = $(".back2");
        const save_btn = $("#save_button");
        const update_btn = $("#update_btn");
        
        
        var request = window.indexedDB.open("notebookDatabase", 1);
        request.onerror = function(event) {
	    console.log("error: ");
        };
        request.onsuccess = function(event) {
	        db = request.result;
	        
        };
        request.onupgradeneeded = function(event) {
	        var db = event.target.result;
	        var objectStore = db.createObjectStore("notes", {autoIncrement : true});
	        
        }
        
        
        
        note_btn.on("click",handleNewNote);
        list_btn.on("click",handleListOfNotes);
        back_btn.on("click",handleBackBtn);
        backSv_btn.on("click",handleBackBtn);
        
        

        function handleNewNote(){
        	$("#save_button").show();
        	$("#update_btn").hide();
            $("#new_note").css("display","block");
            note_btn.css("display","none");
            list_btn.css("display","none");
        }
        function handleListOfNotes(){
            retrieve();
            $("#list_of_notes").css("display","block");
            note_btn.css("display","none");
            list_btn.css("display","none");
        }
        function handleBackBtn(){
            $("#list_of_notes").css("display","none");
            $("#new_note").css("display","none");
            
            $('input[name="title"]').val("");
            $('textarea[name="body"]').val("");
            note_btn.css("display","block");
            list_btn.css("display","block");

        }

        update1 = function(){
        	
        	
            $('#list_of_notes').css("display","block");
            $('#new_note').css("display","none");
            var title = $('input[name="title"]').val();
            var body = $('textarea[name="body"]').val();
            $('input[name="title"]').val("");
            $('textarea[name="body"]').val("");
            
            var msg = {'id':global_key,'title':title,'body':body,'date':new Date().toLocaleString("en-US"),'update':"yes"};
            
            $.ajax({
         	   type: "POST",
         	   url: "NoteHandle",
                contentType: "application/json", 
                data: JSON.stringify(msg),
                success: function(response) {
                	retrieve();
                }
             
          });

     }

        retrieverow  = function(key) 
        {
        	
            $('#list_of_notes').css("display","none");
            $('#new_note').css("display","block");
            
            $("#update_btn").show();
     	   $("#save_button").hide();
            
            
            
            $.ajax({
          	   type: "GET",
          	   url: "NoteHandle",
               contentType: "application/json", 
               data: {'request':"yes",'id_row':key},
               success: function(response) {
            	   
            	   
            	   $('input[name="title"]').val(response.title);
            	   $('textarea[name="body"]').val(response.body);
            	   
            	   
            	   global_key = key;
                   global_date = new Date().toLocaleString();
                   
                   
                }
               
                 
            });
            
            
        }

        retrieve = function() {
        	
        	var table = $('#mytable');
        	var s = `<table><tr><th>Title</th><th>Date</th></tr>`, row=null;
        	
        	$.ajax({
         	   type: "GET",
         	   url: "NoteHandle",
               contentType: "application/json", 
               data:{'request':"hi"},
               
               success: function(response) {
            	   $.each(response, function(index, item) {
            		   
            		   row = `<tr ><td>${item.title}</td><td>${item.date}</td><td><button  class="update_btn"  onclick="retrieverow(${item.id})">Update/View</button> <button class="delete_btn" onclick = "deleteObj(${item.id})">Delete</button></td></tr> `; 
            		   s = s + row;
            		   
            	   });
            	   
            	   table.html(s + "</table>");
               }
                
             
          });
        	
           }
            
        
        
        
        deleteObj = function(key){
        	
        	$.ajax({
           	   type: "GET",
           	   url: "NoteHandle",
                contentType: "application/json", 
                data: {'request':"delete",'id_row':key},
                success: function(response) {
                
             	   retrieve();
                    
                    $("#list_of_notes").css("display","block");
                    
             	   }
                
                  
             });
            
        }
        save = function() {
        	
        	global_key = parseInt(localStorage.getItem("global_key"));
        	localStorage.setItem("global_key",global_key + 1);
        	update = "no";
			note_btn.css("display","block");
            list_btn.css("display","block");
            $("#new_note").css("display","none");
            
            
    
            var title = $('input[name="title"]').val();
            var body = $('textarea[name="body"]').val();
            $('input[name="title"]').val("");
            $('textarea[name="body"]').val("");

            var date = new Date().toLocaleString("en-US");
    
            var msg = {'id':global_key,'title':title,'body':body,'date':date,'update':update};
            
            
            
            msg = JSON.stringify(msg);
            
            
            $.ajax({
            	   type: "POST",
            	   url: "NoteHandle",
                   contentType: "application/json", 
                   data: msg,
                   success: function(response) {
                       window.alert("OK!");
                   }
                
             });
            
            
            retrieve();
        }
    
        
    
        </script>
</body>
</html>
