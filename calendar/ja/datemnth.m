%DATEMNTH  ���͂��ꂽ�����������Ԃ����炷���Ƃɂ��A�����A�܂��ߋ��̓��t���o��
%
%   TargetDate = datemnth(StartDate, NumberMonths, DayFlag,...
%        Basis, EndMonthRule)
%
%   �ڍׁF���̊֐��́A�^����ꂽ�����������Ԃ����炷���Ƃɂ��A���炵��
%         �����A�܂��͉ߋ��̓����V���A���ԍ����t�ŏo�͂��܂��B
%
%   ����:
%     StartDate - �ŏ��̓��t���V���A���ԍ����t�A�܂��́A���t������Ŏ����l��
%       �\������� Nx1 �܂��� 1xN �̃x�N�g���ł��B
%     NumberMonths - �����A�܂��́A�ߋ��ɂǂꂾ�����Ԃ����炷�̂���������
%       �����l�ō\������� Nx1 �܂��� 1xN �̃x�N�g���ł��B���l�͐����łȂ����
%       �Ȃ�܂���B
%     DayFlag - �����A�܂��́A�ߋ��̌��̖ڕW�ƂȂ���t�ɑ΂��Ăǂ̂悤��
%       ���ۂ̓��t�ԍ����o�͂��邩��ݒ肷��l�ō\������� Nx1 �܂��́A
%       1xN �̃x�N�g���ł��B�ȉ��̒l��ݒ肵�܂��B
%       a) DayFlag = 0 (�f�t�H���g) - �J�n���̎��ۂ̓��t�ԍ��ɑΉ�����
%             �����܂��͉ߋ��̌��̓��t�ԍ��ł��B
%       b) DayFlag = 1 - �����A�܂��́A�ߋ��̌��̏������������t�ԍ��ł��B
%       c) DayFlag = 2 - �����A�܂��́A�ߋ��̌��̖������������t�ԍ��ł��B
%     Basis - �ߋ��A�܂��́A�����̓��t���o�͂���Ƃ��ɗp��������v�Z����
%       ������ Nx1 �܂��� 1xN �̃x�N�g���A�܂��́A�X�J���ł��B
%       �ȉ��̒l��ݒ肵�܂��B
%       1) Basis = 0 - actual/actual (�f�t�H���g)
%       2) Basis = 1 - 30/360 SIA
%       3) Basis = 2 - actual/360
%       4) Basis = 3 - actual/365
%       5) Basis = 4 - 30/360 PSA
%       6) Basis = 5 - 30/360 ISDA
%       7) Basis = 6 - 30/360 ���[���b�p
%       8) Basis = 7 - actual/365 ���{
%       9) Basis = 8 - actual/actual ISMA
%      10) Basis = 9 - actual/360 ISMA
%      11) Basis = 10 - actual/365 ISMA
%      12) Basis = 11 - 30/360 ISMA
%      13) Basis = 12 - actual/365 ISDA
%     EndMonthRule - �����K�����L���ł���̂��ǂ������w�肷�� Nx1 �܂��� 
%       1xN �̃x�N�g���A�܂��́A�X�J���l�ł��B
%       1) EndMonthRule = 1 - �K�����L���ł� (���̖������ŏ��̓��t�Ƃ���
%             �ݒ肵�A���Y�̌��� 30 ���ȉ��̏ꍇ�A�����܂��͉ߋ��̑Ή�����
%             ���̓����� 28�A29�A30�A�܂��́A31 ���ł��邩�ǂ����Ɋւ�炸�A
%             �Ή����鏫���A�܂��́A�ߋ��̌��̎��ۂ̖������o�͂����悤��
%             �Ȃ�܂�)�B
%       2) EndMonthRule = 0 (�f�t�H���g) - �����K���͖����ł��B
%
%   �o��:
%     TargetDate - �����A�܂��́A�ߋ��̌��̖ڕW�ƂȂ���������V���A���ԍ����t
%     �ō\������� Nx1 �܂��� 1xN �̃x�N�g���ł��B
%
%   ��:
%     StartDate = '03-Jun-1997';
%     NumberMonths = 6;
%     DayFlag = 0;
%     Basis = 0;
%     EndMonthRule = 1;
%
%     TargetDate = datemnth(StartDate, NumberMonths, DayFlag,...
%          Basis, EndMonthRule)
%
%     �́A�ȉ���Ԃ��܂��B
%
%     TargetDate = 729727 (03-Dec-1997)
%
%   �Q�l DAYS360, DAYS365, DAYSACT, DAYSDIF, WRKDYDIF.


%   Copyright 1995-2008 The MathWorks, Inc.
