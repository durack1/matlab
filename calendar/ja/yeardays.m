%YEARDAYS  �N�̓���
%
%   ND = YEARDAYS(Y)
%   ND = YEARDAYS(Y, Basis)
%
%   �I�v�V�����̓���: Basis
%
%   ����:
%   Y     - �N�� [�X�J���A�܂��̓x�N�g���\��]
%           ��:
%              Y = 1999;
%              Y = 1999:2010;
%
%   �I�v�V�����̓���:
%   Basis - �g�p����� [�X�J���A�܂��̓x�N�g���\����] �����v�Z����
%           ���p�\�Ȓl�͎��̂Ƃ���ł��B
%              0 - actual/actual (�f�t�H���g)
%              1 - 30/360 SIA
%              2 - actual/360
%              3 - actual/365
%              4 - 30/360 PSA
%              5 - 30/360 ISDA
%              6 - 30/360 ���[���b�p
%              7 - actual/365 ���{
%              8 - actual/actual ISMA
%              9 - actual/360 ISMA
%             10 - actual/365 ISMA
%             11 - 30/360 ISMA
%             12 - actual/365 ISDA
%
%   �o��:
%   ND    - [�X�J���A�܂��̓x�N�g���\����] �N Y �ɑΉ��������
%
%   ��:
%      >> nd = yeardays(2000)
%
%      nd =
%
%         366
%
%   �Q�l DAYS360, DAYS365, DAYSACT, YEAR, YEARFRAC.


%   Copyright 1995-2008 The MathWorks, Inc.
