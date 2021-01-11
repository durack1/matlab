%DAYSADD  指定した基準による開始日からの日付
%
%   DAYSADD は、与えられた規準により、D1 から NUM 経過した日数の日付を
%   返します。シリアル番号日付または日付文字列として入力します。
%
%   Date = daysadd(D1, NUM)
%   Date = daysadd(D1, NUM, BASIS)
%
%   オプションの入力: BASIS
%
%   入力:
%      D1    - NDATESx1 または 1xNDATES のシリアル番号日付、または日付文字列
%      NUM   - NNUMx1 または 1xNNUM の整数の行列。
%
%   オプションの入力:
%      BASIS - NBASISx1 または 1xNBASIS の日数計算方式。
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
%
%   出力:
%      Date  -  Nx1 行列のシリアル番号日付
%
%   注意: 30/360 の日数計算方式の性質により、日数計算法の既知の
%         割引のため、日数が離れてしまい、正確な日付を見つけることは可能では
%         ないかもしれません。この事象があるときは警告が表示されます。
%
%  例:
%
%      startDt = datenum('5-Feb-2004');
%      num     = 26;
%      basis   = 1;
%
%      newDt   = daysadd(startDt,num,basis)
%
%      newDt   =
%               732007
%
%  参考 DAYSDIF


% Copyright 1995-2008 The MathWorks, Inc.
