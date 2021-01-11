%DAYSDIF  指定した日数計算方式に基づいた日付間の日数
%
%   DAYSDIF は、与えられた日数計算方式を使って、D1 と D2 間の日数を
%   返します。シリアル番号日付または日付文字列として入力します。最初の日付 
%   (D1) は、最初と最後の日付の間の日数を特定する場合は含まれません。
%
%   D = daysdif(D1, D2)
%   D = daysdif(D1, D2, Basis)
%
%   オプションの入力: Basis
%
%   入力:
%      D1 - 日付の [スカラまたはベクトル]
%
%      D2 - 日付の [スカラまたはベクトル]
%
%   オプションの入力:
%   Basis - 日数計算方式の [スカラまたはベクトル]
%
%      有効な Basis は以下のとおりです。
%            0 = actual/actual (デフォルト)
%            1 = 30/360 SIA
%            2 = actual/360
%            3 = actual/365
%            4 - 30/360 PSA
%            5 - 30/360 ISDA
%            6 - 30/360 ヨーロッパ
%            7 - act/365 日本
%            8 - act/act ISMA
%            9 - act/360 ISMA
%           10 - act/365 ISMA
%           11 - 30/360 ISMA
%           12 - act/365 ISDA


% Copyright 1995-2008 The MathWorks, Inc.
