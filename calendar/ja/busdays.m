%BUSDAYS  �c�Ɠ����V���A�����t�`���Ő���
%
%BUSDAYS �́A�J�n�����܂ފ��Ԃ̍Ō�̉c�Ɠ��ƏI�������܂ފ��Ԃ̍Ō��
%   �c�Ɠ��̊Ԃ̉c�Ɠ��̃x�N�g�����V���A�����t�`���Ő������܂��B
%
%   BDATES = BUSDAYS(SDATE, EDATE, BDMODE)
%   BDATES = BUSDAYS(SDATE, EDATE, BDMODE, HOLVEC)
%
%   ����:
%    SDATE - �V���A���ԍ����t�A�܂��́A������`���̓��t�Ŏw�肵���J�n���B
%
%    EDATE - �V���A���ԍ����t�܂��͕�����`���̓��t�Ŏw�肵���I�����B
%
%   �I�v�V�����̓���:
%   BDMODE - ���ԁB
%            �L���Ȋ��Ԃ͈ȉ����܂݂܂��B
%         (�f�t�H���g)  'DAILY',      'Daily',      'daily',      'D', 'd', 1
%                       'WEEKLY',     'Weekly',     'weekly',     'W', 'w', 2
%                       'MONTHLY',    'Monthly',    'monthly',    'M', 'm', 3
%                       'QUARTERLY',  'Quarterly',  'quarterly',  'Q', 'q', 4
%                       'SEMIANNUAL', 'Semiannual', 'semiannual', 'S', 's', 5
%                       'ANNUAL',     'Annual',     'annual',     'A', 'a', 6
%
%   HOLVEC - �V���A���ԍ����t���A������`���Ŏw�肵���x���x�N�g���B
%
%   �o��:
%   BDATES - �V���A���ԍ����t�ŏo�͂����c�Ɠ��B�c�Ɠ��́A�w�肵�� SDATE �� 
%            EDDATE �̑O�����/�܂��͌�ɂ��邱�Ƃ��ł��܂� (���L�̗���Q��)�B
%
%   ��:
%      vec = datestr(busdays('1/2/01','1/9/01','weekly'))
%      vec =
%      05-Jan-2001
%      12-Jan-2001
%
%      ���j���T�����Ƃ��܂��B1/2/01 (���j) �� 1/9/01 (�Ηj) �̊Ԃł� 1/5/01 
%      (���j) ���B��̏T���ł��B1/09/01 �Ŏ��̏T�𕪊����Ă��܂����A ����
%      ���j�� (1/12/01) ���o�͂���܂��B


%   Copyright 1995-2008 The MathWorks, Inc.
