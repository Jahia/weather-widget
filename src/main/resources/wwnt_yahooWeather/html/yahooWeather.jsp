<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="propertyDefinition" type="org.jahia.services.content.nodetypes.ExtendedPropertyDefinition"--%>
<%--@elvariable id="type" type="org.jahia.services.content.nodetypes.ExtendedNodeType"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addResources type="css" resources="bootstrap.min.css"/>
<template:addResources type="css" resources="weather-icons.css"/>
<template:addResources type="css" resources="weather-icons-wind.css"/>
<template:addResources type="css" resources="flickity.css"/>
<template:addResources type="css" resources="weather-widget.css"/>

<template:addResources type="javascript" resources="jquery.min.js"/>
<template:addResources type="javascript" resources="underscore-min.js"/>
<template:addResources type="javascript" resources="moment-with-locales.js"/>
<template:addResources type="javascript" resources="flickity.pkgd.min.js"/>

<template:addResources type="javascript" resources="i18n/weather-widget-i18n_${currentResource.locale}.js" var="i18nJSFile"/>
<c:if test="${empty i18nJSFile}">
    <template:addResources type="javascript" resources="i18n/weather-widget-i18n.js"/>
</c:if>

<script>
    _.templateSettings = {
        interpolate: /\<\@\=(.+?)\@\>/gim,
        evaluate: /\<\@(.+?)\@\>/gim,
        escape: /\<\@\-(.+?)\@\>/gim
    };

    var unit = '${currentNode.properties["units"].string}';
    var numbersOfDay = '${currentNode.properties["numbersOfDay"].string}';
    var displayWind = ${currentNode.properties["wind"].boolean};
    var displayAtmosphere = ${currentNode.properties["atmosphere"].boolean};
    var displayAstronomy = ${currentNode.properties["astronomy"].boolean};

    var yahooWeatherWidgetTemplate = _.template('<@ var currentDate = moment().locale("${currentResource.locale}"); @>' +
        '<div class="ww-box-full">' +
            '<@ if (displayAstronomy || numbersOfDay === "1") { @>' +
                '<h6><@= weatherWidgetI18n["wwnt_yahooWeather.today"] @> (<@= currentDate.format("ll") @>) <@= query.results.channel.location.city @>, <@= query.results.channel.location.country @></h6>' +
            '<@ } @>' +
            '<@ if (displayAstronomy) { @>' +
            '<@ var sunriseTime = moment(currentDate.format("ll") + query.results.channel.astronomy.sunrise, currentDate._locale._longDateFormat.ll + "H:m a").locale("${currentResource.locale}").format("LT") @>' +
                '<div class="ww-block4">' +
                    '<div class="ww-block12 ww-lineUp">' +
                        '<i class="wi wi-sunrise wi-3x ww-color-sunny" title="<@= weatherWidgetI18n[\'wwnt_yahooWeather.sunriseTime\'] @>"></i>' +
                    '</div>' +
                    '<div class="ww-block12">' +
                        '<p><@= sunriseTime @></p>' +
                    '</div>' +
                '</div>' +
                '<div class="ww-block4">' +
            '<@ } @>' +
            '<@ if (displayAstronomy || numbersOfDay === "1") { @>' +
                '<@ if (!displayAstronomy) { @>' +
                    '<div class="ww-block10">' +
                '<@ } @>' +
                '<div class="ww-block6">' +
                    '<div class="ww-block12 ww-lineUp">' +
                        '<i class="wi wi-yahoo-<@= query.results.channel.item.forecast[0].code @> wi-3x<@ if (query.results.channel.item.forecast[0].code == 32) { @> wi-spin-6s<@ } @>"></i>' +
                    '</div>' +
                    '<div class="ww-block12">' +
                        '<p><@= weatherWidgetI18n["wwnt_yahooWeather.code." + query.results.channel.item.forecast[0].code] @></p>' +
                    '</div>' +
                '</div>' +
                '<div class="ww-block6 ww-lineUp">' +
                    '<div class="ww-block6">' +
                        '<@= query.results.channel.item.forecast[0].high @>' +
                        '<br />' +
                        '<@= query.results.channel.item.forecast[0].low @>' +
                    '</div>' +
                    '<div class="ww-block6">' +
                        '<@ if (unit === "c") { @>' +
                            '<i class="wi wi-celsius wi-3x" title="<@= weatherWidgetI18n[\'wwnt_yahooWeather.temperatureLowHigh\'] @>"></i>' +
                        '<@ } else { @>' +
                            '<i class="wi wi-fahrenheit wi-3x" title="<@= weatherWidgetI18n[\'wwnt_yahooWeather.temperatureLowHigh\'] @>"></i>' +
                        '<@ } @>' +
                    '</div>' +
                '</div>' +
            '</div>' +
            '<@ } @>' +
            '<@ if (displayAstronomy) { @>' +
            '<@ var sunsetTime = moment(currentDate.format("ll") + query.results.channel.astronomy.sunset, currentDate._locale._longDateFormat.ll + "H:m a").locale("${currentResource.locale}").format("LT") @>' +
                '<div class="ww-block4">' +
                '<div class="ww-block12 ww-lineUp">' +
                    '<i class="wi wi-sunset wi-3x ww-color-sunny" title="<@= weatherWidgetI18n[\'wwnt_yahooWeather.sunsetTime\'] @>"></i>' +
                '</div>' +
                '<div class="ww-block12">' +
                    '<p><@= sunsetTime @></p>' +
                '</div>' +
                '</div>' +
            '<@ } @>' +
            '<@ if (displayAtmosphere || displayWind) { @>' +
                '<hr />' +
                '<@ if (displayAtmosphere && displayWind) { @>' +
                    '<div class="ww-block12">' +
                '<@ } @>' +
                '<@ if (displayAtmosphere) { @>' +
                    '<div class="ww-block6">' +
                        '<div class="ww-block6">' +
                            '<i class="wi wi-humidity wi-2x ww-color-shower" title="<@= weatherWidgetI18n[\'wwnt_yahooWeather.atmosphereHumidity\'] @>"></i>' +
                            '<br /><@= query.results.channel.atmosphere.humidity @>' +
                        '</div>' +
                        '<div class="ww-block6">' +
                            '<i class="wi wi-barometer wi-2x" title="<@= weatherWidgetI18n[\'wwnt_yahooWeather.atmospherePressure\'] @>"></i>' +
                            '<br /><@= query.results.channel.atmosphere.pressure @> ' +
                            '<@= query.results.channel.units.pressure @>' +
                        '</div>' +
                    '</div>' +
                '<@ } @>' +
                '<@ if (displayWind) { @>' +
                    '<div class="ww-block6">' +
                        '<div class="ww-block6">' +
                            '<i class="wi wi-thermometer wi-2x" title="<@= weatherWidgetI18n[\'wwnt_yahooWeather.feelsLikeTemperature\'] @>"></i>' +
                            '<br /><@= query.results.channel.wind.chill @> ' +
                            '<@ if (unit === "c") { @>' +
                                '<i class="wi wi-celsius wi-lg"></i>' +
                            '<@ } else { @>' +
                                '<i class="wi wi-fahrenheit wi-lg"></i>' +
                            '<@ } @>' +
                        '</div>' +
                        '<div class="ww-block6">' +
                            '<i class="wi wi-strong-wind wi-2x ww-color-windy" title="<@= weatherWidgetI18n[\'wwnt_yahooWeather.windSpeed\'] @>"></i>' +
                            '<br /><@= query.results.channel.wind.speed @> ' +
                            '<@= query.results.channel.units.speed @>' +
                        '</div>' +
                    '</div>' +
                '<@ } @>' +
                '<@ if (displayAtmosphere && displayWind) { @>' +
                    '</div>' +
                '<@ } @>' +
            '<@ } @>' +
            '<@ if (numbersOfDay === "5") { @>' +
                '<@ if (displayAstronomy || numbersOfDay === "1") { @>' +
                    '<hr />' +
                '<@ } @>' +
                '<div class="ww-block12 ww-block-5days">' +
                    '<div class="gallery js-flickity">' +
                        '<@ _.each(query.results.channel.item.forecast, function(element) { @>' +
                            '<div class="gallery-cell">' +
                                '<h6>' +
                                    '<@= currentDate.format("ll") @>' +
                                '</h6>' +
                                '<div class="ww-block5">' +
                                    '<div class="ww-block12 ww-lineUp">' +
                                        '<i class="wi wi-yahoo-<@= element.code @> wi-3x<@ if (element.code == 32) { @> wi-spin-6s<@ } @>"></i>' +
                                    '</div>' +
                                    '<div class="ww-block12">' +
                                        '<p><@= weatherWidgetI18n["wwnt_yahooWeather.code." + element.code] @></p>' +
                                    '</div>' +
                                '</div>' +
                                '<div class="ww-block5 ww-lineUp">' +
                                    '<div class="ww-block6">' +
                                        '<@= element.high @>' +
                                        '<br />' +
                                        '<@= element.low @>' +
                                        '</div>' +
                                    '<div class="ww-block6">' +
                                        '<@ if (unit === "c") { @>' +
                                            '<i class="wi wi-celsius wi-3x" title="<@= weatherWidgetI18n[\'wwnt_yahooWeather.temperatureLowHigh\'] @>"></i>' +
                                        '<@ } else { @>' +
                                            '<i class="wi wi-fahrenheit wi-3x" title="<@= weatherWidgetI18n[\'wwnt_yahooWeather.temperatureLowHigh\'] @>"></i>' +
                                        '<@ } @>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                            '<@ currentDate = currentDate.add(1, "days"); @>' +
                        '<@ }); @>' +
                    '</div>' +
                '</div>' +
            '<@ } @>' +
        '</div>');


    $(document).ready(function() {
        $.get('<c:url value="${url.base}${functions:escapePath(currentNode.path)}.updateWeather.json"/>', function(result) {
            $('#ww_${currentNode.identifier}').html(yahooWeatherWidgetTemplate(result));
            if ($('.gallery') !== undefined) {
                var $gallery = $('.gallery').flickity();
                $gallery.data('flickity').options.autoPlay = true;
                $gallery.flickity('reloadCells');
            }
        }, 'json');
    });
</script>

<div class="ww-text-center">
    <c:choose>
        <c:when test="${not empty currentNode.properties['jcr:title']}">
            <h1>${currentNode.properties['jcr:title'].string}</h1>
        </c:when>
        <c:otherwise>
            <h1><fmt:message key="wwnt_yahooWeather"/></h1>
        </c:otherwise>
    </c:choose>

    <div id="ww_${currentNode.identifier}">
        <div class="ww-box-small">
            <i class="wi wi-yahoo-32 wi-5x wi-spin-6s"></i>
            <p><fmt:message key="wwnt_yahooWeather.code.32"/></p>
        </div>
    </div>
</div>
