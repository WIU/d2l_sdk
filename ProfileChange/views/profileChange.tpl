<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Profile Change Demo App</title>
    <style type="text/css">
    table.plain
    {
        border-color: transparent;
        border-collapse: collapse;
    }

    table td.plain
    {
        paddding: 5px;
        border-color: transparent;
    }

    table th.plain
    {
        padding: 6px 5px;
        text-align: left;
        border-color: transparent;
    }

    tr:hover
    {
        background-color: transparent !important;
    }
    </style>
    <script src="https://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script>
    <script type="text/javascript">
    // Button Handling Methods
    function getProfile() {
    
      $.ajax({
        url: "/getProfile",
        data: { },
        success: function(data) {
            $('#result').html(data);
        },
        error: function(jqXHR, textStatus, errorThrown) {
            $('#resultHeading').html("Error:");
            $('#result').html(textStatus);
        }
      });
    }

    function updateProfile() {

      var hometown = $('#hometownField').val();
      var city = $('#cityField').val();
      var highschool = $('#highschoolField').val();
      var university = $('#universityField').val();
      var favwebsites = $('#favwebsitesField').val();
      var birthday = $('#birthdayField').val();
      var homephone = $('#homephoneField').val();
      var business = $('#businessField').val();
      var favquotations = $('#favquotationsField').val();
      var futuregoals = $('#futuregoalsField').val();
      var address1 = $('#address1Field').val();
      var province = $('#provinceField').val();
      var postcode = $('#postcodeField').val();
      var favmovies = $('#favmoviesField').val();
      var address2 = $('#address2Field').val();
      var nickname = $('#nicknameField').val();
      var jobtitle = $('#jobtitleField').val();
      var favmemory = $('#favmemoryField').val();
      var favmusic = $('#favmusicField').val();
      var mobilephone = $('#mobilephoneField').val();
      var country = $('#countryField').val();
      var socialmedia = $('#socialmediaField').val();
      var company = $('#companyField').val();
      var favtvshows = $('#favtvshowsField').val();
      var faxnumber = $('#faxnumberField').val();
      var email = $('#emailField').val();
      var favbooks = $('#favbooksField').val();
      var hobbies = $('#hobbiesField').val();
      var homepage = $('#homepageField').val();
    
      $.ajax({
        url: "/updateProfile",
        data: {
          hometown: hometown,
          city: city,
          highschool: highschool,
          university: university,
          favwebsites: favwebsites,
          birthday: birthday,
          homephone: homephone,
          business: business,
          favquotations: favquotations,
          futuregoals: futuregoals,
          address1: address1,
          province: province,
          postcode: postcode,
          favmovies: favmovies,
          address2: address2,
          nickname: nickname,
          jobtitle: jobtitle,
          favmemory: favmemory,
          favmusic: favmusic,
          mobilephone: mobilephone,
          country: country,
          socialmedia: socialmedia,
          company: company,
          favtvshows: favtvshows,
          faxnumber: faxnumber,
          email: email,
          favbooks: favbooks,
          hobbies: hobbies,
          homepage: homepage
        },
        success: function(data){
          $('#result').html(data);
        },
        error: function(jqXHR, textStatus, errorThrown) {
          $('#resultHeading').html("Error:");
          $('#result').html(textStatus);
        }
      });
    }

    function clearTextArea() {
       $("#resultHeading").html("&nbsp;");
       $("#result").html("&nbsp;");
    }

    </script>
</head>
<body>
    <form id="configForm" method="post">
        <table>
            <tr>
                <td><h4>Hometown:</h4></td>
                <td><input id="hometownField" type="text" size=30 value="{{hometown}}" /></td>
                
                <td><h4>City:</h4></td>
                <td><input id="cityField" type="text" size=30 value="{{city}}" /></td>
                
                <td><h4>High School:</h4></td>
                <td><input id="highschoolField" type="text" size=30 value="{{highschool}}" /></td>
                
                <td><h4>University:</h4></td>
                <td><input id="universityField" type="text" size=30 value="{{university}}" /></td>
                
                <td><h4>Fav WebSites:</h4></td>
                <td><input id="favwebsitesField" type="text" size=30 value="{{favwebsites}}" /></td>
            </tr>

            <tr>
                <td><h4>Birthday:</h4></td>
                <td><input id="birthdayField" type="text" size=30 value="{{birthday}}" /></td>
                
                <td><h4>Homephone:</h4></td>
                <td><input id="homephoneField" type="text" size=30 value="{{homephone}}" /></td>
                
                <td><h4>Business:</h4></td>
                <td><input id="businessField" type="text" size=30 value="{{business}}" /></td>
                
                <td><h4>Fav Quotations:</h4></td>
                <td><input id="favquotationsField" type="text" size=30 value="{{favquotations}}" /></td>
                
                <td><h4>Future Goals:</h4></td>
                <td><input id="futuregoalsField" type="text" size=30 value="{{futuregoals}}" /></td>
            </tr>

            <tr>
                <td><h4>Address 1:</h4></td>
                <td><input id="address1Field" type="text" size=30 value="{{address1}}" /></td>
                
                <td><h4>Province:</h4></td>
                <td><input id="provinceField" type="text" size=30 value="{{province}}" /></td>
                
                <td><h4>Postal Code:</h4></td>
                <td><input id="postcodeField" type="text" size=30 value="{{postcode}}" /></td>
                
                <td><h4>Fav Movies:</h4></td>
                <td><input id="favmoviesField" type="text" size=30 value="{{favmovies}}" /></td>
                
                <td><h4>Address 2:</h4></td>
                <td><input id="address2Field" type="text" size=30 value="{{address2}}" /></td>
            </tr>

            <tr>
                <td><h4>Nickname:</h4></td>
                <td><input id="nicknameField" type="text" size=30 value="{{nickname}}" /></td>
                
                <td><h4>Job Title:</h4></td>
                <td><input id="jobtitleField" type="text" size=30 value="{{jobtitle}}" /></td>
                
                <td><h4>Fav Memory:</h4></td>
                <td><input id="favmemoryField" type="text" size=30 value="{{favmemory}}" /></td>
                
                <td><h4>Fav Music:</h4></td>
                <td><input id="favmusicField" type="text" size=30 value="{{favmusic}}" /></td>
                
                <td><h4>Mobile Phone:</h4></td>
                <td><input id="mobilephoneField" type="text" size=30 value="{{mobilephone}}" /></td>
            </tr>

            <tr> 
                <td><h4>Country:</h4></td>
                <td><input id="countryField" type="text" size=30 value="{{country}}" /></td>
                
                <td><h4>Social Media:</h4></td>
                <td><input id="socialmediaField" type="text" size=30 value="{{socialmedia}}" /></td>
                
                <td><h4>Company:</h4></td>
                <td><input id="companyField" type="text" size=30 value="{{company}}" /></td>
                
                <td><h4>Fav TV Shows:</h4></td>
                <td><input id="favtvshowsField" type="text" size=30 value="{{favtvshows}}" /></td>
                
                <td><h4>Fax Number:</h4></td>
                <td><input id="faxnumberField" type="text" size=30 value="{{faxnumber}}" /></td>
            </tr>

            <tr>
                <td><h4>Email:</h4></td>
                <td><input id="emailField" type="text" size=30 value="{{email}}" /></td>
                
                <td><h4>Fav Books:</h4></td>
                <td><input id="favbooksField" type="text" size=30 value="{{favbooks}}" /></td>
                
                <td><h4>Hobbies:</h4></td>
                <td><input id="hobbiesField" type="text" size=30 value="{{hobbies}}" /></td>
                
                <td><h4>Homepage:</h4></td>
                <td><input id="homepageField" type="text" size=30 value="{{homepage}}" /></td>
            </tr>

        </table>
    </form><br /><br />
    <input id="updateProfile" type="button" value="Update" onclick="updateProfile()" /><br /><br /> 
    <hr />

    <table style="float:left;" class = "plain">
        <tr class = "plain">
            <td class = "plain">
                Click to show the current state of your profile on the LMS.
                <input id="getProfile" type="button" value="Show Profile on Server" style="float:right" onclick="getProfile()" /><br /><br />
                <input id="clearButton" type="button" value="Clear" style = "float:right" onclick = "clearTextArea()" />
            </td>
            <td class = "plain">
                <span id = "resultHeading" style = "clear:both;float:left;color: black;" ></span>
                <span id = "result" style = "clear:both;float:left;color: black;text-align:left" ></span>
            </td>
        </tr>
    </table>

</body>
</html>
