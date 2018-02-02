when HTTP_REQUEST {
   HTTP::respond 200 content {
      <html>
         <head>
            <title>Apology Page</title>
         </head>
         <body>
            We are sorry, but the site you are looking for is temporarily out of service
            If you feel you have reached this page in error, please try again.
         </body>
      </html>
   }
}
