%BUSDAYS  営業日をシリアル日付形式で生成
%
%BUSDAYS は、開始日を含む期間の最後の営業日と終了日を含む期間の最後の
%   営業日の間の営業日のベクトルをシリアル日付形式で生成します。
%
%   BDATES = BUSDAYS(SDATE, EDATE, BDMODE)
%   BDATES = BUSDAYS(SDATE, EDATE, BDMODE, HOLVEC)
%
%   入力:
%    SDATE - シリアル番号日付、または、文字列形式の日付で指定した開始日。
%
%    EDATE - シリアル番号日付または文字列形式の日付で指定した終了日。
%
%   オプションの入力:
%   BDMODE - 期間。
%            有効な期間は以下を含みます。
%         (デフォルト)  'DAILY',      'Daily',      'daily',      'D', 'd', 1
%                       'WEEKLY',     'Weekly',     'weekly',     'W', 'w', 2
%                       'MONTHLY',    'Monthly',    'monthly',    'M', 'm', 3
%                       'QUARTERLY',  'Quarterly',  'quarterly',  'Q', 'q', 4
%                       'SEMIANNUAL', 'Semiannual', 'semiannual', 'S', 's', 5
%                       'ANNUAL',     'Annual',     'annual',     'A', 'a', 6
%
%   HOLVEC - シリアル番号日付か、文字列形式で指定した休日ベクトル。
%
%   出力:
%   BDATES - シリアル番号日付で出力される営業日。営業日は、指定した SDATE と 
%            EDDATE の前および/または後にすることができます (下記の例を参照)。
%
%   例:
%      vec = datestr(busdays('1/2/01','1/9/01','weekly'))
%      vec =
%      05-Jan-2001
%      12-Jan-2001
%
%      金曜が週末だとします。1/2/01 (月曜) と 1/9/01 (火曜) の間では 1/5/01 
%      (金曜) が唯一の週末です。1/09/01 で次の週を分割していますが、 次の
%      金曜の (1/12/01) も出力されます。


%   Copyright 1995-2008 The MathWorks, Inc.
