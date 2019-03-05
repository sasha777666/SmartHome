﻿
// Напряжение - Пересчитывает полученные значение с ардуины в напряжение. 
// Возвращает: Напряжение в Вольтах 
// Параметры:
// ЗначениеСАрдуины - Число - Значение полученное Аналоговым пином
// ОпорноеНапряжение - Число - Напряжение относительно которого проводится измерение в Вольтах
// СопрРезистораНаЗемлю - Число - Сопротивление резистора соеденяющего пин с землёй (Необязательный)
// СопрРезистораНаИсточник - Число - Сопротивление резистора соеденяющего пин с источником (Необязательный)
Функция ОпределитьНапряжение(ЗначениеСАрдуины, ОпорноеНапряжение, СопрРезистораНаЗемлю = 0, СопрРезистораНаИсточник = 0) Экспорт
	
	НапряжениеВВольтах = ЗначениеСАрдуины/1023*ОпорноеНапряжение;
	Если СопрРезистораНаЗемлю > 0 И СопрРезистораНаИсточник > 0 Тогда
		НапряжениеВВольтах = НапряжениеВВольтах * (СопрРезистораНаЗемлю + СопрРезистораНаИсточник) / СопрРезистораНаЗемлю			
	КонецЕсли;
	
	Возврат НапряжениеВВольтах; 	
	
КонецФУнкции

// Сопротивление - Пересчитывает полученные значение с ардуины в сопротивление. 
// Возвращает: Сопротивление в Омах (кОмах, мОмах) 
// Параметры:
// ЗначениеСАрдуины - Число - Значение полученное Аналоговым пином
// СопрРезистораНаЗемлю - Число - Сопротивление резистора соеденяющего пин с землёй (в Омах, кОмах, мОмах)
Функция ОпределитьСопротивление(ЗначениеСАрдуины, СопрРезистораНаЗемлю) Экспорт
	
	Если ЗначениеСАрдуины = 0 Тогда // Сопротивление на питание много больше чем на землю 
	Сопротивление = 99999999999999999999999999999999;
	Иначе
		Сопротивление = 1023 / ЗначениеСАрдуины	* СопрРезистораНаЗемлю - СопрРезистораНаЗемлю;
	КонецЕсли;
	
	Возврат Сопротивление;	
	
КонецФункции       
