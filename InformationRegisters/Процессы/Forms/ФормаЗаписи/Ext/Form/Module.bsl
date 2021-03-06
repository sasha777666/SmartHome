﻿
&НаКлиенте
Процедура ОчиститьУникальныйИдентификатор(Команда)
	Запись.УникальныйИдентификатор = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
КонецПроцедуры

&НаКлиенте
Процедура СгенерироватьНовыйУникальныйИдентификатор(Команда)
	Запись.УникальныйИдентификатор = Новый УникальныйИдентификатор();
КонецПроцедуры

&НаСервере
Процедура ПолучитьНовыйКлючФоновогоЗаданияНаСервере()
		
	Запись.КлючФоновогоЗадания = РегистрыСведений.Процессы.НовыйКлючФоновогоЗадания();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНовыйКлючФоновогоЗадания(Команда)
	ПолучитьНовыйКлючФоновогоЗаданияНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОстановитьТекущееФоновоеЗаданиеНаСервере()
	
	НайденноеФонЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Запись.УникальныйИдентификатор);
	Если НайденноеФонЗадание <> Неопределено Тогда 
		НайденноеФонЗадание.Отменить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьТекущееФоновоеЗадание(Команда)
	ОстановитьТекущееФоновоеЗаданиеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОднократноСПроверкойУсловийНаСервере()
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("Наименование", Запись.Наименование);
	Для Каждого Поле Из Метаданные.РегистрыСведений.Процессы.Ресурсы Цикл
		СтруктураПараметров.Вставить(Поле.Имя, Запись[Поле.Имя]);
	КонецЦикла;
	
	СерверПривилегированный.ОбработкаПроцессаДляСтарта(СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОднократноСПроверкойУсловий(Команда)
	ВыполнитьОднократноСПроверкойУсловийНаСервере();
КонецПроцедуры
