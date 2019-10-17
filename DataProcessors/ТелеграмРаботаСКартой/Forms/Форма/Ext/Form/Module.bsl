﻿

&НаСервере
Процедура ИнициализироватьКарту(КодМаршрута = "")

	Текст = ПолучитьТекстМакета();
	ШиротаЦентр = "48.7520";
	ДолготаЦентр = "37.5976";
	Текст = СтрЗаменить(Текст, "&ШиротаЦентр", ШиротаЦентр);
	Текст = СтрЗаменить(Текст, "&ДолготаЦентр", ДолготаЦентр);
	ТекстHTML = СтрЗаменить(Текст, "&КодМаршрута", КодМаршрута);

КонецПроцедуры

&НаСервере
Функция ПолучитьТекстМакета()

	Макет = Обработки.КартаOpenStreetMap.ПолучитьМакет("МакетOSR");
	Результат = Макет.ПолучитьТекст();
	Возврат Результат;

КонецФункции






#Область ОбработчикиСОбытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ИнициализироватьКарту();

КонецПроцедуры

#КонецОбласти







&НаСервере
Функция ОбновитьНаСервере()
		
	КодМаршрута = "markers = new Array(); ";
	
	Для Каждого СтрокаТелеграмКонтакт Из Объект.ТелеграмКонтакты Цикл
		
		ТелеграмКонтакт = СтрокаТелеграмКонтакт.ТелеграмКонтакт;
		
		ЗапросГеоданные = Новый Запрос();
		ЗапросГеоданные.Текст = "ВЫБРАТЬ ПЕРВЫЕ " + Формат(Объект.КоличествоПоследнихТочекМаршрута, "ЧС=; ЧН=0; ЧГ=0") + "
		                        |	ТелеграмГеоданныеКонтакта.Период КАК Период,
		                        |	ТелеграмГеоданныеКонтакта.latitude КАК latitude,
		                        |	ТелеграмГеоданныеКонтакта.longitude КАК longitude
		                        |ИЗ
		                        |	РегистрСведений.ТелеграмГеоданныеКонтакта КАК ТелеграмГеоданныеКонтакта
		                        |ГДЕ
		                        |	ТелеграмГеоданныеКонтакта.ТелеграмКонтакт = &ТелеграмКонтакт
		                        |
		                        |УПОРЯДОЧИТЬ ПО
		                        |	Период УБЫВ";
		ЗапросГеоданные.УстановитьПараметр("ТелеграмКонтакт",ТелеграмКонтакт);
		
		ВыборкаГеоданные = ЗапросГеоданные.Выполнить().Выбрать();
		Если ВыборкаГеоданные.Следующий() Тогда 
			ПериодПоследнейТочки = ВыборкаГеоданные.Период;
			НастройкаЦвета = ТелеграмКонтакт.Настройки.ТаблицаНастроек.Найти("Цвет", "Параметр");
				Если ЗначениеЗаполнено(НастройкаЦвета) Тогда 
					Цвет = НастройкаЦвета.Значение;
				Иначе
					Цвет = "red";
				КонецЕсли;
				
			КодМаршрута = КодМаршрута + "L.marker(["+Формат(ВыборкаГеоданные.latitude, "ЧЦ=16; ЧДЦ=12; ЧРД=.; ЧГ=0")+", "+Формат(ВыборкаГеоданные.longitude, "ЧЦ=16; ЧДЦ=12; ЧРД=.; ЧГ=0")+"], {title: '" + Строка(ТелеграмКонтакт) + "'}).addTo(map);
			|	";	
			ШиротаЦентр = Формат(ВыборкаГеоданные.latitude, "ЧЦ=16; ЧДЦ=12; ЧРД=.; ЧГ=0");
			ДолготаЦентр = Формат(ВыборкаГеоданные.longitude, "ЧЦ=16; ЧДЦ=12; ЧРД=.; ЧГ=0");
			Если ВыборкаГеоданные.Следующий() И ПериодПоследнейТочки <= (ВыборкаГеоданные.Период + 1200) Тогда 
				ПериодПоследнейТочки = ВыборкаГеоданные.Период;
		    	КодМаршрута = КодМаршрута + "var latlngs = [["  + Формат(ВыборкаГеоданные.latitude, "ЧЦ=15; ЧДЦ=12; ЧРД=.; ЧГ=0")+", "+Формат(ВыборкаГеоданные.longitude, "ЧЦ=15; ЧДЦ=12; ЧРД=.; ЧГ=0") + "]";;
				Пока ВыборкаГеоданные.Следующий() И ПериодПоследнейТочки <= (ВыборкаГеоданные.Период + 1200) Цикл
					ПериодПоследнейТочки = ВыборкаГеоданные.Период;
					КодМаршрута = КодМаршрута + ",[" + Формат(ВыборкаГеоданные.latitude, "ЧЦ=15; ЧДЦ=12; ЧРД=.; ЧГ=0")+", "+Формат(ВыборкаГеоданные.longitude, "ЧЦ=15; ЧДЦ=12; ЧРД=.; ЧГ=0") + "]";	
				КонецЦикла;
				
				КодМаршрута = КодМаршрута + "];
				|	var polyline = L.polyline(latlngs, {color: '" + Цвет + "', weight: 5, opacity: 0.7}).addTo(map);
				|	";	
			КонецЕсли;	
		КонецЕсли;	
	
	КонецЦикла;
	
	
	
	Если ЗначениеЗаполнено(КодМаршрута) Тогда
		//var bounds = new L.LatLngBounds(); ids.forEach(function(i) { var infoWindow = L.popup().setContent(contents[i]); var marker = L.marker([lats[i], lons[i]]) .addTo(map) .bindPopup(infoWindow) .openPopup(); bounds.extend(marker.getLatLng()); }); map.fitBounds(bounds); }
		КодМаршрута = КодМаршрута +	"function showLocations(ids, lats, lons, contents) { locationIDs = ids; infoWindows = new Array(); markers = new Array(); map = new L.Map('map_canvas'); var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'; var osmAttrib='Map data © <a href=""http://openstreetmap.org"">OpenStreetMap</a> contributors'; var osm = new L.TileLayer(osmUrl, {minZoom: 1, maxZoom: 19, attribution: osmAttrib}); for (i in ids) { var infoWindow = L.popup() .setContent(contents[i]); map.setView(new L.LatLng(lats[i], lons[i]),18); map.addLayer(osm); L.marker([lats[i], lons[i]]).addTo(map) .bindPopup(infoWindow) .openPopup(); } } 
		//КодМаршрута = КодМаршрута +	"map.fitBounds(polyline.getBounds());
		|	"; 

		Текст = ПолучитьТекстМакета();	
		//ШиротаЦентр = "55.790831000000";
		//ДолготаЦентр = "37.704207000000";	
		Текст = СтрЗаменить(Текст, "&ШиротаЦентр", ШиротаЦентр);
		Текст = СтрЗаменить(Текст, "&ДолготаЦентр", ДолготаЦентр);
		ТекстHTML = СтрЗаменить(Текст, "&КодМаршрута", КодМаршрута);
	Иначе
		ТекстHTML = "";	
	КонецЕсли;
		
	Возврат ТекстHTML; 
	
	
КонецФункции

&НаКлиенте
Процедура Обновить(Команда)
	
	ТекстHTML = ОбновитьНаСервере();
	КодHTML = ТекстHTML; 
	//ФормаКарты = ПолучитьФорму("Обработка.КартаOpenStreetMap.Форма.Форма");
	//ФормаКарты.КодHTML = ТекстHTML;
	//
	//Если ФормаКарты.Открыта() Тогда
	//	ФормаКарты.ОбновитьОтображениеДанных();	
	//Иначе
	//	ФормаКарты.Открыть();
	//КонецЕсли;	
		
КонецПроцедуры

&НаСервере
Процедура ПостроитьТрекНаСервере()
	
		
	ЗапросГеоданных = Новый Запрос();
	ЗапросГеоданных.Текст = "ВЫБРАТЬ
	                        |	ТелеграмГеоданныеКонтакта.Период КАК Период,
	                        |	ТелеграмГеоданныеКонтакта.latitude КАК latitude,
	                        |	ТелеграмГеоданныеКонтакта.longitude КАК longitude
	                        |ИЗ
	                        |	РегистрСведений.ТелеграмГеоданныеКонтакта КАК ТелеграмГеоданныеКонтакта
	                        |ГДЕ
	                        |	ТелеграмГеоданныеКонтакта.ТелеграмКонтакт = &ТелеграмКонтакт
	                        |	И ТелеграмГеоданныеКонтакта.Период МЕЖДУ &ДатаНач И &ДатаКон
	                        |
	                        |УПОРЯДОЧИТЬ ПО
	                        |	Период";
	
	ЗапросГеоданных.УстановитьПараметр("ТелеграмКонтакт", объект.ТелеграмКонтакт);
	ЗапросГеоданных.УстановитьПараметр("ДатаНач", Объект.ДатаНачала);
	ЗапросГеоданных.УстановитьПараметр("ДатаКон", Объект.ДатаОкончания);
	ВыборкаГеоданных = ЗапросГеоданных.Выполнить().Выбрать();
	
	КодМаршрута = "var myIcon = L.icon({iconUrl: 'https://pngicon.ru/file/uploads/telegram-128x128.png', iconSize: [15, 15], iconAnchor: [22, 94], popupAnchor: [-3, -76],  shadowUrl: 'my-icon-shadow.png', shadowSize: [68, 95], shadowAnchor: [22, 94]});";
	
	Пока ВыборкаГеоданных.Следующий() Цикл
	
		//КодМаршрута = КодМаршрута + "L.marker(["+Формат(ВыборкаГеоданных.latitude, "ЧЦ=16; ЧДЦ=12; ЧРД=.; ЧГ=0")+", "+Формат(ВыборкаГеоданных.longitude, "ЧЦ=16; ЧДЦ=12; ЧРД=.; ЧГ=0")+"], {title: '" + Строка(Объект.ТелеграмКонтакт) + "'}).addTo(map);
		//	|	";
		
		КодМаршрута = КодМаршрута + "L.marker(["+Формат(ВыборкаГеоданных.latitude, "ЧЦ=16; ЧДЦ=12; ЧРД=.; ЧГ=0")+", "+Формат(ВыборкаГеоданных.longitude, "ЧЦ=16; ЧДЦ=12; ЧРД=.; ЧГ=0")+"], {icon: myIcon, title: '"+Формат(ВыборкаГеоданных.Период,"ЧФ=; ДФ=ЧЧ:мм")+"'}).addTo(map);
			|	";
	КонецЦикла;
	
	Текст = ПолучитьТекстМакета();
	
	ШиротаЦентр = Формат(ВыборкаГеоданных.latitude, "ЧЦ=16; ЧДЦ=12; ЧРД=.; ЧГ=0");
	ДолготаЦентр = Формат(ВыборкаГеоданных.longitude, "ЧЦ=16; ЧДЦ=12; ЧРД=.; ЧГ=0");
	
	Текст = СтрЗаменить(Текст, "&ШиротаЦентр", ШиротаЦентр);
	Текст = СтрЗаменить(Текст, "&ДолготаЦентр", ДолготаЦентр);
	ТекстHTML = СтрЗаменить(Текст, "&КодМаршрута", КодМаршрута);

	
КонецПроцедуры

&НаКлиенте
Процедура ПостроитьТрек(Команда)
	ПостроитьТрекНаСервере();
КонецПроцедуры




