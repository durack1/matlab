% ISBUSDAY �w�肵�����t���c�Ɠ����ǂ����̔���
%
% T = ISBUSDAY(Date, Holiday, Weekend)
%
% ����:
%        
%   Date    - �ΏۂƂȂ���t�̃x�N�g��
%
% �I�v�V�����̓���:
%
%   HOL     - ���[�U��`�̋x���̃x�N�g���ł��B�f�t�H���g�́A(holidays.m ��)
%             ���炩���ߒ�`����Ă��� US �̋x���ł��B
%
%   WEEKEND - �T���� 1 �Ƃ��� 0 �� 1 ���܂ޒ��� 7 �̃x�N�g���ł��B
%             ���̃x�N�g���̍ŏ��̗v�f�́A���j���ɑΉ����܂��B
%             ���̂��߁A�y�j���Ɠ��j�����T���Ƃ���ƁA
%             WEEKDAY = [1 0 0 0 0 0 1] �ƂȂ�܂��B�f�t�H���g�ł́A
%             �y�j���Ɠ��j�����T���ɂȂ�܂��B
%
% �o��:
%
%   T       - Date ���c�Ɠ��Ȃ� 1�A����ȊO�� 0 ���o�͂��܂��B
%
% ��:
%
%   Date = ['15 feb 2001'; '16 feb 2001'; '17 feb 2001'];
%
%   �Ƃ��āA(holidays.m����) ���炩���ߒ�`����Ă��� US �̋x���x�N�g����
%   �p���āA���j���݂̂��T���Ƃ��ĉc�Ɠ���������ɂ́AMATLAB �Ɉȉ���
%   �悤�Ɏw�����܂��B
%
%   Busday = isbusday(Date, [], [1 0 0 0 0 0 0])
%
% �Q�l BUSDATE, FBUSDATE, HOLIDAYS, LBUSDATE. 


% Copyright 1995-2006 The MathWorks, Inc.
