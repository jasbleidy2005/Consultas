<%@ page import="java.io.*, java.net.*, org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Consumo de APIs</title>
</head>
<body>
<form method="GET">
    <label for="city">Ingrese una ciudad:</label>
    <input type="text" id="city" name="city" value="<%= request.getParameter("city") != null ? request.getParameter("city") : "Bogota" %>" required>

    <label for="date">Seleccione una fecha:</label>
    <input type="date" id="date" name="date" value="<%= request.getParameter("date") != null ? request.getParameter("date") : "2023-12-31" %>" required>

    <input type="submit" value="Consultar">
</form>

<hr>

<%
    if (request.getParameter("city") != null && request.getParameter("date") != null) {
        String city = request.getParameter("city");
        String date = request.getParameter("date");


        String latitude = "4.61";
        String longitude = "-74.08";
        try {

            String geocodingUrl = "https://api.opencagedata.com/geocode/v1/json?q=" + URLEncoder.encode(city, "UTF-8") + "&key=c1896901a50e6fe772db39934769b176";
            URL geocodingApiUrl = new URL(geocodingUrl);
            HttpURLConnection geoConn = (HttpURLConnection) geocodingApiUrl.openConnection();
            geoConn.setRequestMethod("GET");

            int geoResponseCode = geoConn.getResponseCode();
            if (geoResponseCode == 200) {
                BufferedReader geoIn = new BufferedReader(new InputStreamReader(geoConn.getInputStream()));
                StringBuffer geoContent = new StringBuffer();
                String geoLine;
                while ((geoLine = geoIn.readLine()) != null) {
                    geoContent.append(geoLine);
                }
                geoIn.close();

                JSONObject geoJson = new JSONObject(geoContent.toString());
                JSONArray results = geoJson.getJSONArray("results");
                if (results.length() > 0) {
                    JSONObject geometry = results.getJSONObject(0).getJSONObject("geometry");
                    latitude = geometry.getString("lat");
                    longitude = geometry.getString("lng");

                }
            } else {
%>
<p>Error al obtener las coordenadas de la ciudad. Código de respuesta: <%= geoResponseCode %></p>
<%
    }
} catch (Exception e) {
%>
<p>Error al obtener las coordenadas de la ciudad: <%= e.getMessage() %></p>
<%
    }

    try {
        String weatherUrl = "https://api.open-meteo.com/v1/forecast?latitude=" + latitude + "&longitude=" + longitude + "&current_weather=true";
            URL weatherApiUrl = new URL(weatherUrl);
            HttpURLConnection weatherConn = (HttpURLConnection) weatherApiUrl.openConnection();
            weatherConn.setRequestMethod("GET");

            int responseCode = weatherConn.getResponseCode();
            if (responseCode == 200) {
                BufferedReader weatherIn = new BufferedReader(new InputStreamReader(weatherConn.getInputStream()));
                StringBuffer weatherContent = new StringBuffer();
                String weatherLine;
                while ((weatherLine = weatherIn.readLine()) != null) {
                    weatherContent.append(weatherLine);
                }
                weatherIn.close();

                JSONObject weatherJson = new JSONObject(weatherContent.toString());
                JSONObject currentWeather = weatherJson.getJSONObject("current_weather");
                double temperature = currentWeather.getDouble("temperature");

                %>
                <h3>Clima actual en <%= city %>:</h3>
                <p>Temperatura: <%= temperature %> °C</p>
                <%
            } else {
                %>
                <p>Error al obtener el clima. Código de respuesta: <%= responseCode %></p>
                <%
            }
        } catch (Exception e) {
                %>
                <p>Error al obtener los datos del clima: <%= e.getMessage() %></p>
                <%
        }

    try {
            String trmUrl = "https://trm-colombia.vercel.app/?date=" + date;
            URL trmApiUrl = new URL(trmUrl);
            HttpURLConnection trmConn = (HttpURLConnection) trmApiUrl.openConnection();
            trmConn.setRequestMethod("GET");

            int responseCode = trmConn.getResponseCode();
            if (responseCode == 200) {
                BufferedReader trmIn = new BufferedReader(new InputStreamReader(trmConn.getInputStream()));
                StringBuffer trmContent = new StringBuffer();
                String trmLine;
                while ((trmLine = trmIn.readLine()) != null) {
                    trmContent.append(trmLine);
                }
                trmIn.close();

                JSONObject trmJson = new JSONObject(trmContent.toString());
                double trmValue = trmJson.getJSONObject("data").getDouble("value");
                %>
<!-- Mostrar resultados TRM -->
<h3>TRM (Dólar) el <%= date %>:</h3>
<p>Valor: $<%= trmValue %> COP</p>
<%
} else {
%>
<p>Error al obtener la TRM. Código de respuesta: <%= responseCode %></p>
<%
    }
} catch (Exception e) {
%>
<p>Error al obtener los datos de TRM: <%= e.getMessage() %></p>
<%
    }


    try {
        String rickMortyUrl = "https://rickandmortyapi.com/api/character/1"; // Ejemplo: Rick Sanchez
        URL rickMortyApiUrl = new URL(rickMortyUrl);
        HttpURLConnection rickMortyConn = (HttpURLConnection) rickMortyApiUrl.openConnection();
        rickMortyConn.setRequestMethod("GET");

        int responseCode = rickMortyConn.getResponseCode();
        if (responseCode == 200) {
            BufferedReader rickMortyIn = new BufferedReader(new InputStreamReader(rickMortyConn.getInputStream()));
            StringBuffer rickMortyContent = new StringBuffer();
            String rickMortyLine;
            while ((rickMortyLine = rickMortyIn.readLine()) != null) {
                rickMortyContent.append(rickMortyLine);
            }
            rickMortyIn.close();


            JSONObject rickMortyJson = new JSONObject(rickMortyContent.toString());
            String characterName = rickMortyJson.getString("name");
            String characterStatus = rickMortyJson.getString("status");
            String characterSpecies = rickMortyJson.getString("species");

%>

<h3>Personaje de Rick and Morty:</h3>
<p>Nombre: <%= characterName %></p>
<p>Estatus: <%= characterStatus %></p>
<p>Especie: <%= characterSpecies %></p>
<%
} else {
%>
<p>Error al obtener el personaje de Rick and Morty. Código de respuesta: <%= responseCode %></p>
<%
    }
} catch (Exception e) {
%>
<p>Error al obtener los datos de Rick and Morty: <%= e.getMessage() %></p>
<%
        }
    }
%>

</body>
</html>
