﻿
Процедура ПроцессДляСервераПолучитьТекущиеДанные(Процесс = "") Экспорт // Записывается в процессы НазваниеПроцедуры
		
	СтруктураСДанными = ПолучитьДанные();
	ЗаписатьТекущееДанные(СтруктураСДанными);
	
КонецПроцедуры


//////////////////////////////////////////////////////


Функция ПолучитьДанные()
	
	СтрокаОтправки = "?777777777700000000000000000000";

	АйпиАдрес = Оборудование.КонтроллерCOMNET.АдресПорт;
	NETЗапрос = Новый HTTPЗапрос(СтрокаОтправки);  	
	NETСоединение = Новый HTTPСоединение(АйпиАдрес,,,,,5);
	HTTPОтвет = NETСоединение.Получить(NETЗапрос);
	КодСтраницы = HTTPОтвет.ПолучитьТелоКакСтроку();
	
	СтруктураСДанными = Новый Структура();
	
	СветУКрыльцаПозиция = СтрНайти(КодСтраницы, "?777777777702000000000000000000");
	СветУКрыльцаПодстрока = Сред(КодСтраницы, СветУКрыльцаПозиция, 60);
	Если СтрНайти(СветУКрыльцаПодстрока, "1 ON") > 0 Тогда 
		СтруктураСДанными.Вставить("СветУКрыльца", 1);
	ИначеЕсли СтрНайти(СветУКрыльцаПодстрока, "1 OFF") > 0 Тогда 
		СтруктураСДанными.Вставить("СветУКрыльца", 0);
	КонецЕсли;
	
	СветПоКраямПозиция = СтрНайти(КодСтраницы, "?777777777700200000000000000000");
	СветПоКраямПодстрока = Сред(КодСтраницы, СветПоКраямПозиция, 60);
	Если СтрНайти(СветПоКраямПодстрока, "2 ON") > 0 Тогда 
		СтруктураСДанными.Вставить("СветПоКраям", 1);
	ИначеЕсли СтрНайти(СветПоКраямПодстрока, "2 OFF") > 0 Тогда 
		СтруктураСДанными.Вставить("СветПоКраям", 0);
	КонецЕсли;
	
	ОтоплениеТен1Позиция = СтрНайти(КодСтраницы, "?777777777700020000000000000000");
	ОтоплениеТен1Подстрока = Сред(КодСтраницы, ОтоплениеТен1Позиция, 60);
	Если СтрНайти(ОтоплениеТен1Подстрока, "1 ON") > 0 Тогда 
		СтруктураСДанными.Вставить("ОтоплениеТэн1", 1);
	ИначеЕсли СтрНайти(ОтоплениеТен1Подстрока, "1 OFF") > 0 Тогда 
		СтруктураСДанными.Вставить("ОтоплениеТэн1", 0);
	КонецЕсли;
		
	ОтоплениеТен2Позиция = СтрНайти(КодСтраницы, "?777777777700002000000000000000");
	ОтоплениеТен2Подстрока = Сред(КодСтраницы, ОтоплениеТен2Позиция, 60);
	Если СтрНайти(ОтоплениеТен2Подстрока, "2 ON") > 0 Тогда 
		СтруктураСДанными.Вставить("ОтоплениеТэн2", 1);
	ИначеЕсли СтрНайти(ОтоплениеТен2Подстрока, "2 OFF") > 0 Тогда 
		СтруктураСДанными.Вставить("ОтоплениеТэн2", 0);
	КонецЕсли;
	
	
	ВерандаТемператураВлажностьПозиция = СтрНайти(КодСтраницы, "Veranda : t =");
	ВерандаТемператураВлажностьПодстрока = Сред(КодСтраницы, ВерандаТемператураВлажностьПозиция + 14, 70);
	ВерандаТемпература = Лев(ВерандаТемператураВлажностьПодстрока, СтрНайти(ВерандаТемператураВлажностьПодстрока, "&")-1);
	СтруктураСДанными.Вставить("ВерандаТемпература", Число(ВерандаТемпература));
	ВерандаВлажностьПодстрока = Сред(ВерандаТемператураВлажностьПодстрока,СтрНайти(ВерандаТемператураВлажностьПодстрока, "&nbsp h =")+10, 5);
	ВерандаВлажность = Лев(ВерандаВлажностьПодстрока, СтрНайти(ВерандаВлажностьПодстрока, "%")-1);
	СтруктураСДанными.Вставить("ВерандаВлажность", Число(ВерандаВлажность));

	ПрихожкаТемператураВлажностьПозиция = СтрНайти(КодСтраницы, "Prihojka : t =");
	ПрихожкаТемператураВлажностьПодстрока = Сред(КодСтраницы, ПрихожкаТемператураВлажностьПозиция + 15, 70);
	ПрихожкаТемпература = Лев(ПрихожкаТемператураВлажностьПодстрока, СтрНайти(ПрихожкаТемператураВлажностьПодстрока, "&")-1);
	СтруктураСДанными.Вставить("ПрихожкаТемпература", Число(ПрихожкаТемпература));
	ПрихожкаВлажностьПодстрока = Сред(ПрихожкаТемператураВлажностьПодстрока,СтрНайти(ПрихожкаТемператураВлажностьПодстрока, "&nbsp h =")+10, 5);
	ПрихожкаВлажность = Лев(ПрихожкаВлажностьПодстрока, СтрНайти(ПрихожкаВлажностьПодстрока, "%")-1);
	СтруктураСДанными.Вставить("ПрихожкаВлажность", Число(ПрихожкаВлажность));
	
	ВаннаяТемператураВлажностьПозиция = СтрНайти(КодСтраницы, "Vannaya: t =");
	ВаннаяТемператураВлажностьПодстрока = Сред(КодСтраницы, ВаннаяТемператураВлажностьПозиция + 13, 70);
	ВаннаяТемпература = Лев(ВаннаяТемператураВлажностьПодстрока, СтрНайти(ВаннаяТемператураВлажностьПодстрока, "&")-1);
	СтруктураСДанными.Вставить("ВаннаяТемпература", Число(ВаннаяТемпература));
	ВаннаяВлажностьПодстрока = Сред(ВаннаяТемператураВлажностьПодстрока,СтрНайти(ВаннаяТемператураВлажностьПодстрока, "&nbsp h =")+10, 5);
	ВаннаяВлажность = Лев(ВаннаяВлажностьПодстрока, СтрНайти(ВаннаяВлажностьПодстрока, "%")-1);
	СтруктураСДанными.Вставить("ВаннаяВлажность", Число(ВаннаяВлажность));

	ЧердакТемператураВлажностьПозиция = СтрНайти(КодСтраницы, "Ulica: t =");
	ЧердакТемператураВлажностьПодстрока = Сред(КодСтраницы, ЧердакТемператураВлажностьПозиция + 11, 70);
	ЧердакТемпература = Лев(ЧердакТемператураВлажностьПодстрока, СтрНайти(ЧердакТемператураВлажностьПодстрока, "&")-1);
	СтруктураСДанными.Вставить("ЧердакТемпература", Число(ЧердакТемпература));
	ЧердакВлажностьПодстрока = Сред(ЧердакТемператураВлажностьПодстрока,СтрНайти(ЧердакТемператураВлажностьПодстрока, "&nbsp h =")+10, 5);
	ЧердакВлажность = Лев(ЧердакВлажностьПодстрока, СтрНайти(ЧердакВлажностьПодстрока, "%")-1);
	СтруктураСДанными.Вставить("ЧердакВлажность", Число(ЧердакВлажность));
	
	Возврат СтруктураСДанными;
	
КонецФункции


Процедура ЗаписатьТекущееДанные(СтруктураСДанными)
	
	ДатаПолученияДанных = ТекущаяДата();
	Для Каждого Элемент Из СтруктураСДанными Цикл
		ОбщегоНазначения.ЗаписатьДанныеОборудования(Оборудование, Элемент.Ключ, Элемент.Значение, ДатаПолученияДанных); 
	КонецЦикла;
		
КонецПроцедуры

