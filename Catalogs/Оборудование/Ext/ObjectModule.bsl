﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.КонтроллерыCOM") Тогда
		// Заполнение шапки
		КонтроллерCOMNET = ДанныеЗаполнения.Ссылка;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.КонтроллерыNET") Тогда
		// Заполнение шапки
		КонтроллерCOMNET = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры
