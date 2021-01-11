%YEARDAYS  年の日数
%
%   ND = YEARDAYS(Y)
%   ND = YEARDAYS(Y, Basis)
%
%   オプションの入力: Basis
%
%   入力:
%   Y     - 年の [スカラ、またはベクトル表示]
%           例:
%              Y = 1999;
%              Y = 1999:2010;
%
%   オプションの入力:
%   Basis - 使用される [スカラ、またはベクトル表示の] 日数計算方式
%           利用可能な値は次のとおりです。
%              0 - actual/actual (デフォルト)
%              1 - 30/360 SIA
%              2 - actual/360
%              3 - actual/365
%              4 - 30/360 PSA
%              5 - 30/360 ISDA
%              6 - 30/360 ヨーロッパ
%              7 - actual/365 日本
%              8 - actual/actual ISMA
%              9 - actual/360 ISMA
%             10 - actual/365 ISMA
%             11 - 30/360 ISMA
%             12 - actual/365 ISDA
%
%   出力:
%   ND    - [スカラ、またはベクトル表示の] 年 Y に対応する日数
%
%   例:
%      >> nd = yeardays(2000)
%
%      nd =
%
%         366
%
%   参考 DAYS360, DAYS365, DAYSACT, YEAR, YEARFRAC.


%   Copyright 1995-2008 The MathWorks, Inc.
