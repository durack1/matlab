% THIRDWEDNESDAY  �^����ꂽ�N�ƌ��̑�3���j��
%
% ���̊֐��́A�^����ꂽ�N�ƌ��̑�3���j���������܂��B
%
%   [BeginDates, EndDates] = thirdwednesday(Month, Year)
%
% ����:
%     Month - ���[���_���[�̐敨/ LIBOR �_���N�s1��̎�n�����x�N�g���B
%             
%      Year - ���[���_���[�̐敨/ LIBOR �_�񌎂ɑΉ�����N�s1���
%             4���\���̔N�̃x�N�g���B
%
% �o��:
%      BeginDates - �w�肳�ꂽ�N�ƌ��̑�O���j���B�����3�������Ԍ_��̏����B
%
%        EndDates - �N�ƌ��Ŏw�肳���3�����Ԃ̌_��̖����B
%
% ����: 1. ���ׂĂ̓��t�́A�V���A���ԍ��ł��B
%          DATESTR ���g���ĕ�����ɕϊ����邱�Ƃ��ł��܂��B
%       2. ����̌��ƔN��^�����ꍇ�A�֐��͓������ʂ�Ԃ��܂��B
%
% ��:
%      Months = [10; 10; 10];
%      Year = [2002; 2003; 2004];
%
%      [BeginDates, EndDates] = thirdwednesday(Months, Year)
%      
%      BeginDates =
%            731505
%            731869
%            732240
%      EndDates =
%            731597
%            731961
%            732332


%   Copyright 2002-2006 The MathWorks, Inc.
