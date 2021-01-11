%BUSDATE  次または前の営業日
%
%   BD = busdate(D)
%   BD = busdate(D, DIREC, HOL, WEEKEND)
%
%   オプションの入力: DIREC, HOL, WEEKEND
%
%   入力:
%         D - シリアル番号日付または日付文字列として参照する営業日のスカラ、
%             ベクトル、または、行列。
%
%   オプションの入力:
%     DIREC - 探索方向のスカラ、ベクトル、または、行列:
%             次 (DIREC = 1, デフォルト) の営業日か、前 (DIREC = -1) の営業日
%
%       HOL - シリアル番号日付または日付文字列としての休業日のスカラ、
%             または、ベクトル。HOL の指定がない場合は、ルーチン HOLIDAYS で
%             決定されます。現時点では、NYSE 休日のみ HOLIDAYS でサポート
%             されています。
%
%   WEEKEND - 0 と 1 を含む長さ 7 のベクトル。値 1 は週末を示します。
%             このベクトルの最初の要素は、Sunday に対応します。たとえば、
%             Saturday と Sunday が週末とすると、WEEKEND = [1 0 0 0 0 0 1] 
%             となります。
%
%   出力:
%        BD - HOL に依存する次または前の営業日のスカラ、ベクトル、または、行列。
%
%   例:
%      bd = busdate('3-jul-1997', 1)
%      bd =
%          729578 % 07-Jul-1997
%
%  参考 HOLIDAYS, ISBUSDAY.


%  Copyright 1995-2008 The MathWorks, Inc.
