% BASIS は、債券に適用される基準、または、日数カウント基準のことです。
% 日数カウント基準は、通例、2つの日付間の日数を計算する方法を表す分子と
% 年の日数を示す分母で構成される分数で表示されます。たとえば、
% "ACTUAL/ACTUAL" は、2つの日付間の日数を計算するときに、実際の日数を
% カウントしなければならないことを意味しています。
% 分母は、日数計算の時に与えられた年の実際の日数が使用されることを意味し
% ています(すなわち、与えられた年が閏年であるかどうかによって1年が365日
% または、366日であるとして計算されるということを意味しています)。入力で
% きる値は、つぎの通りです。
%     1)Basis = 0 - actual/actual (ほとんどの関数において、デフォルト)。
%     2)Basis = 1 - 30/360
%     3)Basis = 2 - actual/360
%     4)Basis = 3 - actual/365


%Author(s): C. Bassignani, 03-11-98
%   Copyright 1995-2003 The MathWorks, Inc.
